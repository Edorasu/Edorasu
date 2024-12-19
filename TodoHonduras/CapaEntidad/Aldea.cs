namespace CapaEntidad
{
    public class Aldea
    {
        public string IdAldea { get; set; }
        public string Descripcion { get; set; }
        public Municipio oMunicipio { get; set; }
        public Departamento oDepartamento { get; set; }
    }
}
