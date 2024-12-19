namespace CapaEntidad
{
    public class Municipio
    {
        public string IdMunicipio { get; set; }
        public string Descripcion { get; set; }
        public Departamento Departamento { get; set; }
    }
}
