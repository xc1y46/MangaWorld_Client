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
        public ActionResult Index(string mangaId, int? PageSize, int? Page, bool? sortAsc, bool? commentEnab)
        {
            if (String.IsNullOrEmpty(mangaId) || mangaId == "none")
            {
                //return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
                return RedirectToAction("Index", "Home");
            }
            Manga manga;

            if(mangaId == "random")
            {
                List<Manga> mangas = db.Manga.Include(m => m.Status1).Include(m => m.Comment).Include(m => m.Language).Where(m => m.IsPublished && !m.Deleted).ToList();
                Random r = new Random();
                manga = mangas[r.Next(0, mangas.Count)];
            }
            else
            {
                manga = db.Manga.Where(m => m.MangaId == mangaId && m.IsPublished && !m.Deleted).FirstOrDefault();

                if (manga == null)
                {
                    return RedirectToAction("Index", "Home");
                }

                manga = db.Manga.Include(m => m.Status1).Include(m => m.Comment).Include(m => m.Language).Where(m => m.MangaId == mangaId && m.IsPublished && !m.Deleted).FirstOrDefault();
            }

            int tempPageSize = (PageSize ?? 10);
            int PageNumber = (Page ?? 1);
            ViewData["ChapSortAsc"] = (sortAsc != null) ? sortAsc : false;
            ViewData["UserCurrRating"] = -1;
            ViewData["UserBookmark"] = false;
            ViewData["UserId"] = -1;

            if (Utils.userChecking())
            {
                int userid = (int)Session["UserId"];
                string username = (string)Session["UserName"];
                User user = db.User.Where(u => !u.Deleted && u.UserId == userid && u.UserName == username).FirstOrDefault();
                if(user != null)
                {
                    Rating tempScore = db.Rating.Where(r => r.MangaId == mangaId && r.UserId == user.UserId).FirstOrDefault();
                    if (tempScore != null) ViewData["UserCurrRating"] = tempScore.Score;
                    ViewData["UserBookmark"] = (user.Bookmarks.Contains(mangaId));
                    ViewData["UserId"] = userid;
                }
            }

            bool tempComments = (commentEnab ?? false);
            ViewData["EnableComment"] = tempComments;
            

            if (tempComments)
            {
                var temp = db.Comment.Include(c => c.User).Where(c => c.MangaId == manga.MangaId).OrderByDescending(c => c.CommentDate);
                ViewData["Comment"] = temp.ToPagedList(PageNumber, tempPageSize);
            }
            else
            {
                var temp = db.Chapter.Where(c => c.MangaId == manga.MangaId).OrderBy(c => c.ChapterOrder);

                if (!(bool)ViewData["ChapSortAsc"])
                {
                    temp = temp.OrderByDescending(c => c.ChapterOrder);
                }
                ViewData["Chapter"] = temp.ToPagedList(PageNumber, tempPageSize);
            }

            ViewData["Rating"] = Utils.getRating(manga);
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
