using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;

namespace CapaNegocio
{
    public class CN_Cliente
    {
        private CD_Cliente objCapaDato = new CD_Cliente();

        public int Registrar(Cliente obj, out string Mensaje)
        {
            Mensaje = String.Empty;

            if (string.IsNullOrEmpty(obj.Nombres) || string.IsNullOrWhiteSpace(obj.Nombres))
            {
                Mensaje = "El nombre del Cliente no puede ser vacio";
            }

            else if (string.IsNullOrEmpty(obj.Apellidos) || string.IsNullOrWhiteSpace(obj.Apellidos))
            {
                Mensaje = "El Apellido del Cliente no puede ser vacio";
            }

            else if (string.IsNullOrEmpty(obj.Correo) || string.IsNullOrWhiteSpace(obj.Correo))
            {
                Mensaje = "El Correo del Cliente no puede ser vacio";
            }

            if (string.IsNullOrEmpty(Mensaje))
            {
                obj.Clave = CN_Recursos.ConvertirSha256(obj.Clave);
                return objCapaDato.Registrar(obj, out Mensaje);

            }

            else
            {
                return 0;
            }

        }

        public List<Cliente> Listar()
        {
            return objCapaDato.Listar();
        }


        public bool CambiarClave(int idcliente, string nuevaclave, out string Mensaje)
        {
            return objCapaDato.CambiarClave(idcliente, nuevaclave, out Mensaje);
        }

        public bool ReestablecerClave(int idcliente, string correo, out string Mensaje)
        {
            Mensaje = string.Empty;
            string nuevaclave = CN_Recursos.GenerarClave();
            string claveAnterior = string.Empty;

            try
            {
                // Obtener la clave anterior antes de modificarla
                claveAnterior = objCapaDato.ObtenerClave(idcliente); // Asegúrate de tener un método que recupere la clave anterior

                // Actualizar la clave en la base de datos
                bool resultado = objCapaDato.ReestablecerClave(idcliente, CN_Recursos.ConvertirSha256(nuevaclave), out Mensaje);

                if (resultado)
                {
                    string asunto = "Contraseña Reestablecida";
                    string mensaje_correo = "<h3>Su cuenta fue reestablecida correctamente</h3></br><p>Su contraseña para acceder ahora es: !clave!</p>";
                    mensaje_correo = mensaje_correo.Replace("!clave!", nuevaclave);

                    // Intentar enviar el correo
                    bool respuesta = CN_Recursos.EnviarCorreo(correo, asunto, mensaje_correo);

                    if (respuesta)
                    {
                        return true; // Si el correo se envía, todo está correcto
                    }
                    else
                    {
                        // Si no se pudo enviar el correo, restaurar la clave
                        objCapaDato.ReestablecerClave(idcliente, claveAnterior, out Mensaje); // Restaurar la clave anterior
                        Mensaje = "No se pudo enviar el correo, la clave ha sido restaurada a su valor anterior";
                        return false;
                    }
                }
                else
                {
                    Mensaje = "No se pudo reestablecer la contraseña";
                    return false;
                }
            }
            catch (Exception ex)
            {
                // En caso de excepciones, restaurar la clave y manejar el error
                if (!string.IsNullOrEmpty(claveAnterior))
                {
                    objCapaDato.ReestablecerClave(idcliente, claveAnterior, out Mensaje); // Restaurar la clave
                }
                Mensaje = "Hubo un error al procesar la solicitud: " + ex.Message;
                return false;
            }
        }
    }
}
