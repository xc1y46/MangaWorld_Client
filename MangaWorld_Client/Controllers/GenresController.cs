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

            switch (sortOpt)
            {
                case "timeDes":
                    {
                        temp.Sort((x,y) => x.ReleasedYear.CompareTo(y.ReleasedYear));
                        temp.Reverse();
                        break;
                    }
                case "timeAsc":
                    {
                        temp.Sort((x, y) => x.ReleasedYear.CompareTo(y.ReleasedYear));
                        break;
                    }
                case "scoreDes":
                    {
                        temp.Sort((x, y) => Utils.getRatingScore(Utils.getRating(x)).CompareTo(Utils.getRatingScore(Utils.getRating(y))));
                        temp.Reverse();
                        break;
                    }
                case "scoreAsc":
                    {
                        temp.Sort((x, y) => Utils.getRatingScore(Utils.getRating(x)).CompareTo(Utils.getRatingScore(Utils.getRating(y))));
                        break;
                    }
                case "followDes":
                    {
                        temp.Sort((x,y) => Utils.getBookmarkCount(x).CompareTo(Utils.getBookmarkCount(y)));
                        temp.Reverse();
                        break;
                    }
                case "followAsc":
                    {
                        temp.Sort((x, y) => Utils.getBookmarkCount(x).CompareTo(Utils.getBookmarkCount(y)));
                        break;
                    }
                default:
                    {
                        temp.Sort((x, y) => x.ReleasedYear.CompareTo(y.ReleasedYear));
                        temp.Reverse();
                        break;
                    }
            }

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
