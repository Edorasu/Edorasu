using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;

namespace CapaNegocio
{
    public class CN_Usuario
    {
        private CD_Usuario objCapaDato = new CD_Usuario();

        public List<Usuario> Listar()
        {
            return objCapaDato.Listar();
        }

        public int Registrar(Usuario obj, out string Mensaje)
        {
            Mensaje = String.Empty;

            if (string.IsNullOrEmpty(obj.Nombres) || string.IsNullOrWhiteSpace(obj.Nombres))
            {
                Mensaje = "El nombre del Usuario no puede ser vacio";
            }

            else if (string.IsNullOrEmpty(obj.Apellidos) || string.IsNullOrWhiteSpace(obj.Apellidos))
            {
                Mensaje = "El Apellido del Usuario no puede ser vacio";
            }

            else if (string.IsNullOrEmpty(obj.Correo) || string.IsNullOrWhiteSpace(obj.Correo))
            {
                Mensaje = "El Correo del Usuario no puede ser vacio";
            }

            if (string.IsNullOrEmpty(Mensaje))
            {

                //ENVIAR CLAVE A LOS USUARIOS


                string clave = CN_Recursos.GenerarClave();

                string asunto = "Creacion de Cuenta";
                string mensaje_correo = "<h3>Su cuenta fue creada correctamente</h3></br><p>Su contraseña para acceder es: !clave!</p>";
                mensaje_correo = mensaje_correo.Replace("!clave!", clave);

                bool respuesta = CN_Recursos.EnviarCorreo(obj.Correo, asunto, mensaje_correo);

                if (respuesta)
                {
                    obj.Clave = CN_Recursos.ConvertirSha256(clave);
                    return objCapaDato.Registrar(obj, out Mensaje);
                }
                else
                {
                    Mensaje = "No se puede enviar el correo";
                    return 0;
                }


            }

            else
            {
                return 0;
            }

        }

        public bool Editar(Usuario obj, out string Mensaje)
        {
            Mensaje = String.Empty;

            if (string.IsNullOrEmpty(obj.Nombres) || string.IsNullOrWhiteSpace(obj.Nombres))
            {
                Mensaje = "El nombre del Usuario no puede ser vacio";
            }

            else if (string.IsNullOrEmpty(obj.Apellidos) || string.IsNullOrWhiteSpace(obj.Apellidos))
            {
                Mensaje = "El Apellido del Usuario no puede ser vacio";
            }

            else if (string.IsNullOrEmpty(obj.Correo) || string.IsNullOrWhiteSpace(obj.Correo))
            {
                Mensaje = "El Correo del Usuario no puede ser vacio";
            }

            if (string.IsNullOrEmpty(Mensaje))
            {
                return objCapaDato.Editar(obj, out Mensaje);

            }
            else
            {
                return false;
            }
        }
        public bool Eliminar(int id, out string Mensaje)
        {
            return objCapaDato.Eliminar(id, out Mensaje);
        }

        public bool CambiarClave(int idusuario, string nuevaclave, out string Mensaje)
        {
            return objCapaDato.CambiarClave(idusuario, nuevaclave, out Mensaje);
        }

        public bool ReestablecerClave(int idusuario, string correo, out string Mensaje)
        {
            Mensaje = string.Empty;
            string nuevaclave = CN_Recursos.GenerarClave();
            string claveAnterior = string.Empty;

            try
            {
                // Obtener la clave anterior antes de modificarla
                claveAnterior = objCapaDato.ObtenerClave(idusuario); // Asegúrate de tener un método que recupere la clave anterior

                // Actualizar la clave en la base de datos
                bool resultado = objCapaDato.ReestablecerClave(idusuario, CN_Recursos.ConvertirSha256(nuevaclave), out Mensaje);

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
                        objCapaDato.ReestablecerClave(idusuario, claveAnterior, out Mensaje); // Restaurar la clave anterior
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
                    objCapaDato.ReestablecerClave(idusuario, claveAnterior, out Mensaje); // Restaurar la clave
                }
                Mensaje = "Hubo un error al procesar la solicitud: " + ex.Message;
                return false;
            }
        }

    }
}
