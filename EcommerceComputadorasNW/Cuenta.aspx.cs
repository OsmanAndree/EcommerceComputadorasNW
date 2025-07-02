using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace EcommerceComputadorasNW
{
    public partial class Cuenta : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["usuario"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    string correo = Session["usuario"].ToString();
                    CargarDatosUsuario(correo);
                }
            }
        }

        private void CargarDatosUsuario(string correo)
        {
            string connectionString = "Data Source=.;Initial Catalog=EcommerceComputadoras;Integrated Security=True";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT NomUsu, CorUsu, TelUsu, RolUsu FROM Usuarios WHERE CorUsu = @correo";

                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@correo", correo);

                connection.Open();
                SqlDataReader reader = command.ExecuteReader();

                if (reader.Read())
                {
                    lblNomUsu.Text = reader["NomUsu"].ToString();
                    lblCorreo.Text = reader["CorUsu"].ToString();
                    lblNombreCompleto.Text = reader["NomUsu"].ToString();

                    Session["NomUsu"] = reader["NomUsu"].ToString();
                    Session["CorUsu"] = reader["CorUsu"].ToString();
                    Session["TelUsu"] = reader["TelUsu"].ToString();
                    Session["RolUsu"] = reader["RolUsu"].ToString();
                }

                reader.Close();
            }
        }

    }
}
