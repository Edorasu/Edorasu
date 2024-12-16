    using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CapaEntidad;
using CapaNegocio;
using System.Globalization;
using ClosedXML.Excel;
using System.IO;

namespace CapaPresentacionAdmin.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public JsonResult VistaDashBoard()
        {
            DashBoard objeto = new CN_Reporte().VerDashBoard();

            return Json(new { resultado = objeto }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult ListaReporte( string fechainicio, string fechafin, string idtransaccion)
        {

            List<Reporte> oLista = new List<Reporte>();

            oLista = new CN_Reporte().Ventas(fechainicio, fechafin, idtransaccion);

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public FileResult ExportarVenta(string fechainicio, string fechafin, string idtransaccion)
        {
            List<Reporte> oLista = new List<Reporte>();
            oLista = new CN_Reporte().Ventas(fechainicio, fechafin, idtransaccion);

            DataTable dt = new DataTable();

            dt.Locale = new CultureInfo("es-HN");
            dt.Columns.Add("Fecha Venta", typeof(string));
            dt.Columns.Add("Cliente", typeof(string));
            dt.Columns.Add("Producto", typeof(string));
            dt.Columns.Add("Precio", typeof(string));
            dt.Columns.Add("Cantidad", typeof(string));
            dt.Columns.Add("Total", typeof(string));
            dt.Columns.Add("IdTransaccion", typeof(string));

            foreach (Reporte rp in oLista)
            {
                dt.Rows.Add(new object[]
                {
                    rp.FechaVenta,
                    rp.Cliente,
                    rp.Producto,
                    rp.Precio,
                    rp.Cantidad,
                    rp.Total,
                    rp.IdTransaccion,
                });

            }

            dt.TableName = "Datos";

            using (XLWorkbook wb = new XLWorkbook())
            {
                wb.Worksheets.Add(dt);
                using (MemoryStream stream = new MemoryStream())
                {
                    wb.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheettml.sheet", "ReporteVenta" + DateTime.Now.ToString() + ".xlsx");
                }
            }
        }

        #region USUARIO
        public ActionResult Usuarios()
        {
            return View();
        }

        [HttpGet]
        public JsonResult ListarUsuarios()
        {
            List<Usuario> oLista = new List<Usuario>();

            oLista = new CN_Usuario().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult GuardarUsuarios(Usuario objeto)
        {
            object resultado;

            string mensaje = string.Empty;

            if (objeto.IdUsuario == 0)
            {
                resultado = new CN_Usuario().Registrar(objeto, out mensaje);
            }
            else
            {
                resultado = new CN_Usuario().Editar(objeto, out mensaje);
            }

            return Json(new { resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult EliminarUsuarios(int id)
        {
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Usuario().Eliminar(id, out mensaje);

            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }

        #endregion
    }
}