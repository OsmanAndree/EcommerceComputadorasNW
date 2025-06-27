using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceComputadorasNW
{
    public partial class Productos : Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["conexionDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCategorias();
                CargarMarcas();
                CargarProductos();
                productsGrid.Attributes["class"] = $"products-grid {CurrentView}-view";
            }
        }
        private string CurrentView
        {
            get
            {
                if (Session["CurrentView"] == null)
                    return "grid";
                return Session["CurrentView"].ToString();
            }
            set
            {
                Session["CurrentView"] = value;
            }
        }
        public string GetProductCardClass()
        {
            return CurrentView == "list" ? "product-card list-view" : "product-card";
        }
        private void CargarCategorias()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT CatID, NomCat FROM Categorias WHERE EstCat = 1";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                cblCategorias.DataSource = dt;
                cblCategorias.DataTextField = "NomCat";
                cblCategorias.DataValueField = "CatID";
                cblCategorias.DataBind();
            }
        }


        private void CargarMarcas()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT MarcID, NomMarc FROM Marcas WHERE EstMarc = 1";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                cblMarcas.DataSource = dt;
                cblMarcas.DataTextField = "NomMarc";
                cblMarcas.DataValueField = "MarcID";
                cblMarcas.DataBind();
            }
        }

        protected void Filtros_Changed(object sender, EventArgs e)
        {
            CargarProductos();
        }

        private void CargarProductos()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT p.ProID, p.NomPro, p.DescPro, p.PrePro, p.ImaPro,
                         c.NomCat, m.NomMarc, p.RatingPro, p.ReviewsPro
                         FROM Productos p
                         INNER JOIN Categorias c ON p.CatID = c.CatID
                         INNER JOIN Marcas m ON p.MarcID = m.MarcID
                         WHERE p.EstPro = 1";

                // Agregar filtros por categoría
                var categoriasSeleccionadas = cblCategorias.Items.Cast<ListItem>().Where(i => i.Selected).Select(i => i.Value).ToList();
                if (categoriasSeleccionadas.Any())
                {
                    string inClause = string.Join(",", categoriasSeleccionadas);
                    query += $" AND p.CatID IN ({inClause})";
                }

                // Agregar filtros por marca
                var marcasSeleccionadas = cblMarcas.Items.Cast<ListItem>().Where(i => i.Selected).Select(i => i.Value).ToList();
                if (marcasSeleccionadas.Any())
                {
                    string inClause = string.Join(",", marcasSeleccionadas);
                    query += $" AND p.MarcID IN ({inClause})";
                }

                // Filtro de precios
                if (decimal.TryParse(txtMinPrecio.Text, out decimal minPrecio))
                {
                    query += $" AND p.PrePro >= {minPrecio}";
                }
                if (decimal.TryParse(txtMaxPrecio.Text, out decimal maxPrecio))
                {
                    query += $" AND p.PrePro <= {maxPrecio}";
                }

                // Ordenamiento
                string orden = ddlOrdenar.SelectedValue;
                switch (orden)
                {
                    case "price-low": query += " ORDER BY p.PrePro ASC"; break;
                    case "price-high": query += " ORDER BY p.PrePro DESC"; break;
                    case "rating": query += " ORDER BY p.RatingPro DESC"; break;
                    case "newest": query += " ORDER BY p.ProID DESC"; break;
                    default: query += " ORDER BY p.ProID DESC"; break;
                }

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptProductos.DataSource = dt;
                rptProductos.DataBind();

                productsCount.InnerText = dt.Rows.Count.ToString();
            }
        }


        public string GenerarEstrellas(decimal rating)
        {
            int fullStars = (int)Math.Floor(rating);
            bool halfStar = (rating % 1) != 0;
            int emptyStars = 5 - (fullStars + (halfStar ? 1 : 0));

            string stars = "";
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