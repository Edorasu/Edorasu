using CapaDatos;
using CapaEntidad;
using System.Collections.Generic;

namespace CapaNegocio
{
    public class CN_Ubicacion
    {
        private CD_Ubicacion objCapaDato = new CD_Ubicacion();

        public List<Departamento> ObtenerDepartamento()
        {
            return objCapaDato.ObtenerDepartamento();
        }

        public List<Municipio> ObtenerMunicipio(string iddepartamento)
        {
            return objCapaDato.ObtenerMunicipio(iddepartamento);
        }

        public List<Aldea> ObtenerAldea(string iddepartamento, string idmunicipio)
        {
            return objCapaDato.ObtenerAldea(iddepartamento, idmunicipio);
        }

    }
}
