using CapaEntidad;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace CapaDatos
{
    public class CD_Ubicacion
    {
        public List<Departamento> ObtenerDepartamento()
        {
            List<Departamento> lista = new List<Departamento>();

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "Select * from DEPARTAMENTO";

                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                                new Departamento
                                {
                                    IdDepartamento = dr["IdDepartamento"].ToString(),
                                    Descripcion = dr["Descripcion"].ToString()
                                });
                        }
                    }
                }
            }
            catch
            {
                lista = new List<Departamento>();
            }
            return lista;
        }

        public List<Municipio> ObtenerMunicipio(string iddepartamento)
        {
            List<Municipio> lista = new List<Municipio>();

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "Select * from Municipio where IdDepartamento = @iddepartamento";

                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.Parameters.AddWithValue("@iddepartamento", iddepartamento);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                                new Municipio
                                {
                                    IdMunicipio = dr["IdMunicipio"].ToString(),
                                    Descripcion = dr["Descripcion"].ToString()
                                });
                        }
                    }
                }
            }
            catch
            {
                lista = new List<Municipio>();
            }
            return lista;
        }

        public List<Aldea> ObtenerAldea(string iddepartamento, string idmunicipio)
        {
            List<Aldea> lista = new List<Aldea>();

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "Select * from Aldea where IdMunicipio = @idmunicipio and IdDepartamento = @iddepartamento";

                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.Parameters.AddWithValue("@iddepartamento", iddepartamento);
                    cmd.Parameters.AddWithValue("@idmunicipio", idmunicipio);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                                new Aldea
                                {
                                    IdAldea = dr["IdAldea"].ToString(),
                                    Descripcion = dr["Descripcion"].ToString()
                                });
                        }
                    }
                }
            }
            catch
            {
                lista = new List<Aldea>();
            }
            return lista;
        }

    }
}
