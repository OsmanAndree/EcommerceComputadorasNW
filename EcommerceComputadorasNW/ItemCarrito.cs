using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EcommerceComputadorasNW
{
    public class ItemCarrito
    {
        public int ProductoID { get; set; }
        public string Nombre { get; set; }
        public decimal Precio { get; set; }
        public string Imagen { get; set; }
        public int Cantidad { get; set; }
    }

}