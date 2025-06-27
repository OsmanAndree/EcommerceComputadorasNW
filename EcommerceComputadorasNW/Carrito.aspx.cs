using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceComputadorasNW
{
    public partial class Carrito : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["conexionDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            CargarCarrito();
            // 👇 Registra el script en cada carga de página
            string script = @"
        document.addEventListener('DOMContentLoaded', function () {
            const shippingOptions = document.querySelectorAll('input[name$=""shipping""]');
            shippingOptions.forEach(radio => {
                radio.addEventListener('change', updateSummary);
            });
            updateSummary(); // Ejecutar al cargar
        });

        function updateSummary() {
            const subtotalSpan = document.getElementById('" + subtotal.ClientID + @"');
            let subtotalValue = parseFloat(subtotalSpan.innerText.replace(/[^0-9.-]+/g, ''));

            const selectedShipping = document.querySelector('input[name$=""shipping""]:checked');
            let shippingValue = 0;
            if (selectedShipping) {
                const priceSpan = selectedShipping.nextElementSibling.querySelector('.shipping-price');
                shippingValue = parseFloat(priceSpan.innerText.replace(/[^0-9.-]+/g, ''));
            }

            const discountSpan = document.getElementById('" + discount.ClientID + @"');
            let discountValue = parseFloat(discountSpan.innerText.replace(/[^0-9.-]+/g, ''));

            const totalValue = subtotalValue + shippingValue + discountValue;

            document.getElementById('" + shipping.ClientID + @"').innerText = '$' + shippingValue.toFixed(2);
            document.getElementById('" + total.ClientID + @"').innerText = '$' + totalValue.toFixed(2);
        }
    ";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "UpdateSummaryScript", script, true);
        }
        private void CargarCarrito()
        {
            if (Session["Carrito"] != null && ((DataTable)Session["Carrito"]).Rows.Count > 0)
            {
                DataTable carrito = (DataTable)Session["Carrito"];

                // 1. Mostrar los productos y ocultar el mensaje de "vacío"
                rptCarrito.DataSource = carrito;
                rptCarrito.DataBind();
                rptCarrito.Visible = true;
                pnlCarritoVacio.Visible = false;

                // 2. Calcular y mostrar los totales
                decimal subtotalValue = carrito.AsEnumerable().Sum(r => Convert.ToDecimal(r["Subtotal"]));
                decimal shippingValue = 0.00m; // Por defecto, el envío es gratis
                decimal discountValue = 0.00m; // Aún no hay lógica de cupones
                decimal totalValue = subtotalValue + shippingValue - discountValue;

                subtotal.InnerText = subtotalValue.ToString("C"); // "C" formatea como moneda
                shipping.InnerText = shippingValue.ToString("C");
                discount.InnerText = "-" + discountValue.ToString("C");
                total.InnerText = totalValue.ToString("C");
            }
            else
            {
                // Si el carrito está vacío, ocultar la lista y mostrar el mensaje
                rptCarrito.Visible = false;
                pnlCarritoVacio.Visible = true;
            }
        }

        protected void btnPagar_Click(object sender, EventArgs e)
        {
            if (Session["Carrito"] != null && ((DataTable)Session["Carrito"]).Rows.Count > 0)
            {
                DataTable carrito = (DataTable)Session["Carrito"];

                // Usamos "using" para asegurar que la conexión y la transacción se cierren correctamente
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    using (SqlTransaction trans = con.BeginTransaction())
                    {
                        try
                        {
                            // PASO 1: Insertar en la tabla maestra `Carrito`
                            int usuarioID = 2; // Usuario de ejemplo
                            if (Session["UserID"] != null)
                            {
                                usuarioID = Convert.ToInt32(Session["UserID"]);
                            }

                            string insertCarritoQuery = @"
                        INSERT INTO Carrito (UsuID, FechCre, EstCar) 
                        OUTPUT INSERTED.CarID 
                        VALUES (@UsuID, @FechCre, @EstCar)";

                            int carritoID;
                            using (SqlCommand cmd = new SqlCommand(insertCarritoQuery, con, trans))
                            {
                                cmd.Parameters.AddWithValue("@UsuID", usuarioID);
                                cmd.Parameters.AddWithValue("@FechCre", DateTime.Now);
                                cmd.Parameters.AddWithValue("@EstCar", 1); // 1 = Completado
                                carritoID = (int)cmd.ExecuteScalar();
                            }

                            // PASO 2: Insertar los detalles
                            // 👇 CAMBIO CLAVE: Definimos el comando y los parámetros UNA SOLA VEZ, fuera del bucle.
                            string insertDetalleQuery = @"
                        INSERT INTO CarritoDetalle (CarID, ProID, CantPro, PrecUni, FechAg)
                        VALUES (@CarID, @ProID, @CantPro, @PrecUni, @FechAg)";

                            using (SqlCommand cmdDetalle = new SqlCommand(insertDetalleQuery, con, trans))
                            {
                                // Definimos los parámetros que vamos a usar en el bucle
                                cmdDetalle.Parameters.Add("@CarID", SqlDbType.Int);
                                cmdDetalle.Parameters.Add("@ProID", SqlDbType.Int);
                                cmdDetalle.Parameters.Add("@CantPro", SqlDbType.Int);
                                cmdDetalle.Parameters.Add("@PrecUni", SqlDbType.Decimal);
                                cmdDetalle.Parameters.Add("@FechAg", SqlDbType.DateTime);

                                foreach (DataRow row in carrito.Rows)
                                {
                                    // Actualizamos los valores de los parámetros en cada iteración
                                    cmdDetalle.Parameters["@CarID"].Value = carritoID;
                                    cmdDetalle.Parameters["@ProID"].Value = row["ProID"];
                                    cmdDetalle.Parameters["@CantPro"].Value = row["Cantidad"];
                                    cmdDetalle.Parameters["@PrecUni"].Value = row["Precio"];
                                    cmdDetalle.Parameters["@FechAg"].Value = DateTime.Now;

                                    cmdDetalle.ExecuteNonQuery(); // Ejecutamos el comando
                                }
                            }

                            trans.Commit(); // Confirmamos la transacción SÓLO si todo salió bien

                            // Limpiar carrito y redirigir
                            Session["Carrito"] = null;
                            pnlCompraExitosa.Visible = true;  // Muestra el panel de éxito
                            rptCarrito.Visible = false;       // Oculta la lista de productos
                            pnlCarritoVacio.Visible = false;  // Oculta el mensaje de carrito vacío
                            subtotal.InnerText = "$0.00";
                            discount.InnerText = "-$0.00";
                            shipping.InnerText = "$0.00";
                            total.InnerText = "$0.00";
                            btnPagar.Visible = false;
                            var badgeControl = this.Master.FindControl("cartCountBadge") as System.Web.UI.HtmlControls.HtmlGenericControl;
                            if (badgeControl != null)
                            {
                                string script = $"updateCartBadge(0, '{badgeControl.ClientID}');";
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "cartReset", script, true);
                            }
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            Response.Write("Error al procesar el pago: " + ex.Message);
                        }
                    }
                }
            }
            else
            {
                Response.Write("No hay productos en el carrito.");
            }
        }
    }
}