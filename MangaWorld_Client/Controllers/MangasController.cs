using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MangaWorld_Client.Models;

namespace MangaWorld_Client.Controllers
{
    public class MangasController : Controller
    {
        private ContextModel db = new ContextModel();

        // GET: Mangas
        public ActionResult Index(string mangaId)
        {
            if (String.IsNullOrEmpty(mangaId) || mangaId == "none")
            {
                //return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                return RedirectToAction("Index", "Home");
            }

            Manga manga = db.Manga.Include(m => m.Status1).Where(m => m.MangaId == mangaId && m.IsPublished && !m.Deleted).FirstOrDefault();

            if (manga == null)
            {
                return HttpNotFound();
            }

            ViewData["AltTitle"] = manga.AltTitle.Split('*');
            ViewData["Rating"] = Utils.getRating(manga, db);
            ViewData["Bookmark"] = Utils.getBookmarkCount(manga, db);
            ViewData["Genres"] = Utils.getGenre(manga, db);
            ViewData["Comment"] = db.Comment.Include(m => m.User).Where(c => c.MangaId == mangaId).ToList();

            return View(manga);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
