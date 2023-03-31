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
    public class GenresController : Controller
    {
        private ContextModel db = new ContextModel();

        // GET: Genres
        public ActionResult Index(string genreId, int? PageSize, int? Page, string sortOpt)
        {
            if (String.IsNullOrEmpty(genreId))
            {
                return RedirectToAction("Index", "Home");
            }
            Genre genre = db.Genre.Find(genreId);
            if (genre == null)
            {
                return RedirectToAction("Index", "Home");
            }

            int tempPageSize = (PageSize ?? 10);
            int PageNumber = (Page ?? 1);

            var temp = db.Manga.Where(m => !m.Deleted && m.IsPublished && m.Genres.Contains(genreId)).OrderBy(m => m.ReleasedYear).ToList();

            ViewData["CurrSort"] = String.IsNullOrEmpty(sortOpt) ? "timeDes" : sortOpt;

            temp = Utils.sortManga(sortOpt, temp);

            ViewData["CurrGenre"] = genre;

            return View(temp.ToPagedList(PageNumber, tempPageSize));
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
