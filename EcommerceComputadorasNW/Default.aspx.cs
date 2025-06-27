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
            string connectionString = ConfigurationManager.ConnectionStrings["conexionDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"SELECT TOP 9 ProID, NomPro, PrePro, ImaPro, RatingPro, ReviewsPro
                         FROM Productos
                         WHERE EstPro = 1";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptProductos.DataSource = dt;
                rptProductos.DataBind();
            }
        }

        public string GenerarEstrellas(decimal rating)
        {
            int fullStars = (int)Math.Floor(rating);
            bool halfStar = (rating % 1) != 0;
            int emptyStars = 5 - (fullStars + (halfStar ? 1 : 0));

            string stars = new string('<', 0); // reset
            for (int i = 0; i < fullStars; i++)
                stars += "<i class='fas fa-star'></i>";

            if (halfStar)
                stars += "<i class='fas fa-star-half-alt'></i>";

            for (int i = 0; i < emptyStars; i++)
                stars += "<i class='far fa-star'></i>";

            return stars;
        }
    }
}