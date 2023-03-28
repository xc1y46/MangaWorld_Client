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
    public class ChaptersController : Controller
    {
        private ContextModel db = new ContextModel();

        // GET: Chapters
        public ActionResult Index(string mangaId, string chapOrd)
        {
            if (String.IsNullOrEmpty(mangaId) || mangaId == "none" || String.IsNullOrEmpty(chapOrd))
            {
                //return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                return RedirectToAction("Index", "Home");
            }

            float? tempChapOrd = float.Parse(chapOrd);

            Chapter chapter = db.Chapter.Include(c => c.Manga).Where(c => c.MangaId == mangaId && c.ChapterOrder == tempChapOrd && c.IsPublished && !c.Deleted && !c.Manga.Deleted && c.Manga.IsPublished).FirstOrDefault();

            if (chapter == null)
            {
                return RedirectToAction("Index", "Home");
            }

            List<Chapter> chapters = db.Chapter.Where(c => c.MangaId == mangaId && c.IsPublished && !c.Deleted && !c.Manga.Deleted && c.Manga.IsPublished).ToList();

            //null when index is first or last
            ViewData["ChapList"] = chapters;
            int i = chapters.FindIndex(c => c.ChapterOrder == tempChapOrd);
            if(i < chapters.Count-1)
            {
                ViewData["NextChap"] = i + 1;
            }
            else
            {
                ViewData["NextChap"] = null;
            }
            
            if(i > 0)
            {
                ViewData["PrevChap"] = i-1;
            }
            else
            {
                ViewData["PrevChap"] = null;
            }

            return View(chapter);
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
