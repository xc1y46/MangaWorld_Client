using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using MangaWorld_Client.Models;
using PagedList;

namespace MangaWorld_Client.Controllers
{
    public class MangasController : Controller
    {
        private ContextModel db = new ContextModel();

        // GET: Mangas
        public ActionResult Index(string mangaId, int? PageSize, int? Page, bool? sortAsc)
        {
            if (String.IsNullOrEmpty(mangaId) || mangaId == "none")
            {
                //return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                return RedirectToAction("Index", "Home");
            }

            Manga manga = db.Manga.Where(m => m.MangaId == mangaId && m.IsPublished && !m.Deleted).FirstOrDefault();

            if (manga == null)
            {
                return RedirectToAction("Index", "Home");
            }

            manga = db.Manga.Include(m => m.Status1).Include(m => m.Comment).Include(m => m.Language).Where(m => m.MangaId == mangaId && m.IsPublished && !m.Deleted).FirstOrDefault();

            int tempPageSize = (PageSize ?? 10);
            int PageNumber = (Page ?? 1);

            ViewData["ChapSortAsc"] = (sortAsc != null) ? sortAsc : false;

            var temp = db.Chapter.Where(c => c.MangaId == mangaId).OrderBy(c => c.ChapterOrder);

            ViewData["FirstChap"] = temp.ToList()[0].ChapterOrder;

            if (!(bool)ViewData["ChapSortAsc"])
            {
                temp = temp.OrderByDescending(c => c.ChapterOrder);
            }

            ViewData["Rating"] = Utils.getRating(manga);
            ViewData["Chapter"] = temp.ToPagedList(PageNumber, tempPageSize);
            ViewData["Genres"] = Utils.getGenre(manga);

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
