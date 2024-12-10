using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using CapaDatos;
using CapaEntidad;

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
    }
}
