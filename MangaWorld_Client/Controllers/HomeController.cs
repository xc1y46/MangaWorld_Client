using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using MangaWorld_Client.Models;

namespace MangaWorld_Client.Controllers
{
    public class HomeController : Controller
    {
        private ContextModel db = new ContextModel();
        public ActionResult Index()
        {
            var manga = db.Manga.Where(m => m.IsPublished).Include(m => m.Author).Include(m => m.Language).Include(m => m.Status1);
            return View(manga.ToList());
        }
    }
}