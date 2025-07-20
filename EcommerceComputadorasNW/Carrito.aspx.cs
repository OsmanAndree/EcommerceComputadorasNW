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

                rptCarrito.DataSource = carrito;
                rptCarrito.DataBind();
                rptCarrito.Visible = true;
                pnlCarritoVacio.Visible = false;
                pnlCartActions.Visible = true;
                pnlResumen.Visible = true;
                btnPagar.Visible = true;

                decimal subtotalValue = carrito.AsEnumerable().Sum(r => Convert.ToDecimal(r["Subtotal"]));
                decimal shippingValue = 0.00m;
                decimal discountValue = 0.00m;
                decimal totalValue = subtotalValue + shippingValue - discountValue;

                subtotal.InnerText = subtotalValue.ToString("C");
                shipping.InnerText = shippingValue.ToString("C");
                discount.InnerText = "-" + discountValue.ToString("C");
                total.InnerText = totalValue.ToString("C");
            }
            else
            {
                rptCarrito.Visible = false;
                pnlCarritoVacio.Visible = true;
                pnlCartActions.Visible = false;
                pnlResumen.Visible = false;
                btnPagar.Visible = false;
            }
        }

        protected void btnVaciarCarrito_Click(object sender, EventArgs e)
        {
            Session["Carrito"] = null;
            rptCarrito.Visible = false;
            pnlCarritoVacio.Visible = true;
            pnlCartActions.Visible = false;
            pnlResumen.Visible = false;
            btnPagar.Visible = false;

            subtotal.InnerText = "$0.00";
            discount.InnerText = "-$0.00";
            shipping.InnerText = "$0.00";
            total.InnerText = "$0.00";

            var badgeControl = this.Master.FindControl("cartCountBadge") as System.Web.UI.HtmlControls.HtmlGenericControl;
            if (badgeControl != null)
            {
                string script = $"updateCartBadge(0, '{badgeControl.ClientID}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "cartCleared", script, true);
            }
        }

        protected void btnPagar_Click(object sender, EventArgs e)
        {
            if (Session["Carrito"] != null && ((DataTable)Session["Carrito"]).Rows.Count > 0)
            {
                DataTable carrito = (DataTable)Session["Carrito"];

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    using (SqlTransaction trans = con.BeginTransaction())
                    {
                        try
                        {
                            int usuarioID = 2; 
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

                            string insertDetalleQuery = @"
                        INSERT INTO CarritoDetalle (CarID, ProID, CantPro, PrecUni, FechAg)
                        VALUES (@CarID, @ProID, @CantPro, @PrecUni, @FechAg)";

                            using (SqlCommand cmdDetalle = new SqlCommand(insertDetalleQuery, con, trans))
                            {
                                cmdDetalle.Parameters.Add("@CarID", SqlDbType.Int);
                                cmdDetalle.Parameters.Add("@ProID", SqlDbType.Int);
                                cmdDetalle.Parameters.Add("@CantPro", SqlDbType.Int);
                                cmdDetalle.Parameters.Add("@PrecUni", SqlDbType.Decimal);
                                cmdDetalle.Parameters.Add("@FechAg", SqlDbType.DateTime);

                                foreach (DataRow row in carrito.Rows)
                                {
                                    cmdDetalle.Parameters["@CarID"].Value = carritoID;
                                    cmdDetalle.Parameters["@ProID"].Value = row["ProID"];
                                    cmdDetalle.Parameters["@CantPro"].Value = row["Cantidad"];
                                    cmdDetalle.Parameters["@PrecUni"].Value = row["Precio"];
                                    cmdDetalle.Parameters["@FechAg"].Value = DateTime.Now;

                                    cmdDetalle.ExecuteNonQuery(); // Ejecutamos el comando
                                }
                            }

                            trans.Commit(); 

                            Session["Carrito"] = null;
                            //pnlCompraExitosa.Visible = true;  
                            rptCarrito.Visible = false;       
                            pnlCarritoVacio.Visible = false;  
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
                        Response.Redirect("Pedido.aspx");

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