using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaEntidad
{
    public class Aldea
    {
        public int IdAldea { get; set; }
        public string Descripcion { get; set; }
        public Municipio oMunicipio { get; set; }
        public Departamento oDepartamento { get; set; }
    }
}
