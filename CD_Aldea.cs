using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaDatos
{
    public class CD_Aldea
    {

        public List<Aldea> Listar()
        {
            List<Aldea> lista = new List<Aldea>();

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    StringBuilder sb = new StringBuilder();

                    // Corregir la consulta SQL para darle el alias a la columna Descripcion
                    sb.AppendLine("SELECT a.IdDistrito, a.IdAldea, a.Descripcion[DesAldea], m.IdMunicipio, m.Descripcion, d.IdDepartamento[ID], d.Descripcion[DesDepartamento]");
                    sb.AppendLine("FROM ALDEA a");
                    sb.AppendLine("INNER JOIN MUNICIPIO m ON m.IdMunicipio = a.IdMunicipio");
                    sb.AppendLine("INNER JOIN DEPARTAMENTO d ON d.IdDepartamento = m.IdDepartamento");

                    SqlCommand cmd = new SqlCommand(sb.ToString(), oconexion);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                                new Aldea
                                {
                                    IdDistrito = Convert.ToInt32(dr["IdDistrito"]),
                                    IdAldea = dr["IdAldea"].ToString(),
                                    Descripcion = dr["DesAldea"].ToString(),
                                    oMunicipio = new Municipio()
                                    {
                                        IdMunicipio = dr["IdMunicipio"].ToString(),
                                        Descripcion = dr["Descripcion"].ToString() // Usamos el alias corregido aquí
                                    },
                                    oDepartamento = new Departamento()
                                    {
                                        IdDepartamento = dr["ID"].ToString(),
                                        Descripcion = dr["DesDepartamento"].ToString() // Usamos el alias corregido aquí
                                    }
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


        public int Registrar(Aldea obj, out string Mensaje)
        {
            int idautogenerado = 0;

            Mensaje = string.Empty;
            try
            {

                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_RegistrarAldea", oconexion);
                    cmd.Parameters.AddWithValue("IdAldea", obj.IdAldea);
                    cmd.Parameters.AddWithValue("Descripcion", obj.Descripcion);
                    cmd.Parameters.AddWithValue("IdMunicipio", obj.oMunicipio.IdMunicipio);
                    cmd.Parameters.AddWithValue("IdDepartamento", obj.oDepartamento.IdDepartamento);
                    cmd.Parameters.Add("Resultado", SqlDbType.Int).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();
                    idautogenerado = Convert.ToInt32(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                idautogenerado = 0;
                Mensaje = ex.Message;
            }
            return idautogenerado;
        }

        public bool Editar(Aldea obj, out string Mensaje)
        {
            bool resultado = false;

            Mensaje = string.Empty;
            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_EditarAldea", oconexion);
                    cmd.Parameters.AddWithValue("IdDistrito", obj.IdDistrito);
                    cmd.Parameters.AddWithValue("IdAldea", obj.IdAldea);
                    cmd.Parameters.AddWithValue("Descripcion", obj.Descripcion);
                    cmd.Parameters.AddWithValue("IdMunicipio", obj.oMunicipio.IdMunicipio);
                    cmd.Parameters.AddWithValue("IdDepartamento", obj.oDepartamento.IdDepartamento);
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                Mensaje = ex.Message;
            }
            return resultado;
        }

        public bool Eliminar(int id, out string Mensaje)
        {
            bool resultado = false;

            Mensaje = string.Empty;
            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_EliminarAldea", oconexion);
                    cmd.Parameters.AddWithValue("IdDistrito", id);
                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                Mensaje = ex.Message;
            }
            return resultado;
        }
    }
}
