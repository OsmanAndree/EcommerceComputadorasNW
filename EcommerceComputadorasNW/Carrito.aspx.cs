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
            if (!IsPostBack)
            {
                CargarCarrito();
            }

        }
        private void CargarCarrito()
        {
            if (Session["Carrito"] != null)
            {
                DataTable carrito = (DataTable)Session["Carrito"];
                rptCarrito.DataSource = carrito;
                rptCarrito.DataBind();
            }
        }

        protected void btnPagar_Click(object sender, EventArgs e)
        {
            if (Session["Carrito"] != null)
            {
                DataTable carrito = (DataTable)Session["Carrito"];

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    con.Open();
                    SqlTransaction trans = con.BeginTransaction();

                    try
                    {
                        // Insertar encabezado de carrito
                        SqlCommand cmd = new SqlCommand("INSERT INTO Carrito (Fecha, Total) OUTPUT INSERTED.CarritoID VALUES (@Fecha, @Total)", con, trans);
                        cmd.Parameters.AddWithValue("@Fecha", DateTime.Now);
                        cmd.Parameters.AddWithValue("@Total", carrito.AsEnumerable().Sum(r => Convert.ToDecimal(r["Subtotal"])));
                        int carritoID = (int)cmd.ExecuteScalar();

                        // Insertar cada producto como detalle
                        foreach (DataRow row in carrito.Rows)
                        {
                            SqlCommand cmdDetalle = new SqlCommand(@"INSERT INTO CarritoDetalle (CarritoID, ProductoID, Cantidad, PrecioUnitario, Subtotal)
                                                             VALUES (@CarritoID, @ProductoID, @Cantidad, @PrecioUnitario, @Subtotal)", con, trans);
                            cmdDetalle.Parameters.AddWithValue("@CarritoID", carritoID);
                            cmdDetalle.Parameters.AddWithValue("@ProductoID", row["ProID"]);
                            cmdDetalle.Parameters.AddWithValue("@Cantidad", row["Cantidad"]);
                            cmdDetalle.Parameters.AddWithValue("@PrecioUnitario", row["Precio"]);
                            cmdDetalle.Parameters.AddWithValue("@Subtotal", row["Subtotal"]);
                            cmdDetalle.ExecuteNonQuery();
                        }

                        trans.Commit();

                        // Limpiar carrito y redirigir
                        Session["Carrito"] = null;
                        Response.Redirect("CompraRealizada.aspx");
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        // Muestra error en pantalla o loguealo
                        Response.Write("Error al procesar el pago: " + ex.Message);
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