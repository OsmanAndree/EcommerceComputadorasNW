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
    public partial class _Default : Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["conexionDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCategorias();
                CargarProductos();
            }
        }

        private void CargarCategorias()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT CatID, NomCat, ImgCat FROM Categorias WHERE EstCat = 1";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCategorias.DataSource = dt;
                rptCategorias.DataBind();
            }
        }

        private void CargarProductos()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 8 ProID, NomPro, PrePro, ImaPro 
                    FROM Productos 
                    WHERE EstPro = 1 
                    ORDER BY NEWID()"; // Trae 8 productos al azar destacados

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptProductos.DataSource = dt;
                rptProductos.DataBind();
            }
        }
    }
}