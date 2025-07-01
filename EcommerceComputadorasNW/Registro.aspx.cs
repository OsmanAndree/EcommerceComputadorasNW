using System;
using System.Data.SqlClient;
using System.Configuration;

namespace EcommerceComputadorasNW
{
    public partial class Registro : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["conexionDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private void MostrarToast(string mensaje, string tipo)
        {
            string cssClass = tipo == "success" ? "toast-success" : "toast-error";

            string toastHtml = $@"
                <div id='toastMessage' class='toast-container {cssClass} show'>
                    <span>{mensaje}</span>
                    <button class='toast-close' onclick='this.parentElement.style.display=""none"";'>&times;</button>
                </div>";

            litToast.Text = toastHtml;
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            string nombre = firstName.Value + " " + lastName.Value;
            string correo = registerEmail.Value;
            string contrasena = registerPassword.Value;
            string telefono = phone.Value;

            int telefonoInt = 0;
            if (!string.IsNullOrEmpty(telefono))
                int.TryParse(telefono, out telefonoInt);

            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Usuarios (UsuID, NomUsu, CorUsu, ConUsu, TelUsu, EstUsu, RolUsu)
                                     VALUES ((SELECT ISNULL(MAX(UsuID), 0) + 1 FROM Usuarios), @Nom, @Cor, @Con, @Tel, 1, 0)";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Nom", nombre);
                    cmd.Parameters.AddWithValue("@Cor", correo);
                    cmd.Parameters.AddWithValue("@Con", contrasena);
                    cmd.Parameters.AddWithValue("@Tel", telefonoInt);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();

                    MostrarToast("Usuario registrado exitosamente", "success");


                    Response.Redirect("Login.aspx");
                }
            }
            catch (Exception ex)
            {
                MostrarToast("Error al registrar usuario", "error");

                Response.Write($"<script>alert('Error: {ex.Message}');</script>");
            }
        }
    }
}
