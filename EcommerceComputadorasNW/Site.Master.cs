using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceComputadorasNW
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Carrito"] != null)
            {
                DataTable carrito = (DataTable)Session["Carrito"];
                if (carrito.Rows.Count > 0)
                {
                    // Suma la columna "Cantidad" de todas las filas del carrito
                    int totalItems = carrito.AsEnumerable().Sum(row => row.Field<int>("Cantidad"));
                    cartCountBadge.InnerText = totalItems.ToString();
                }
                else
                {
                    cartCountBadge.InnerText = "0";
                }
            }
            else
            {
                cartCountBadge.InnerText = "0";
            }

        }
    }
}