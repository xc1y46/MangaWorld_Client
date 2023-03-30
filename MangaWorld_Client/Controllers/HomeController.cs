using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using MangaWorld_Client.Models;
using PagedList;

namespace MangaWorld_Client.Controllers
{
    public class HomeController : Controller
    {
        private ContextModel db = new ContextModel();
        public ActionResult Index()
        {
            var manga = db.Manga.Where(m => m.IsPublished && !m.Deleted).Include(m => m.Author).Include(m => m.Language).Include(m => m.Status1);
            return View(manga.ToList());
        }

        public ActionResult Search(string nameSrc, string langSrc, string statusSrc, string genreSrc, int? PageSize, int? Page, string sortOpt)
        {
            var temp = db.Manga.Where(m => m.IsPublished && !m.Deleted).Include(m => m.Author).Include(m => m.Language).Include(m => m.Status1);

            int tempPageSize = (PageSize ?? 10);
            int PageNumber = (Page ?? 1);
            ViewData["Language"] = db.Language.ToList();
            ViewData["Status"] = db.Status.ToList();
            ViewData["Genre"] = db.Genre.ToList();


            ViewData["CurrName"] = String.IsNullOrEmpty(nameSrc) ? "" : nameSrc;
            ViewData["CurrStatus"] = String.IsNullOrEmpty(statusSrc) ? "any" : statusSrc;
            ViewData["CurrLang"] = String.IsNullOrEmpty(langSrc) ? "any" : langSrc;
            ViewData["CurrSort"] = String.IsNullOrEmpty(sortOpt) ? "scoreDes" : sortOpt;
            ViewData["CurrGenre"] = String.IsNullOrEmpty(genreSrc) ? "" : genreSrc;

            if (!String.IsNullOrEmpty(langSrc) && langSrc != "any")
            {
                foreach (Language l in (List<Language>)ViewData["Language"])
                {
                    if (l.LanguageId == langSrc)
                    {
                        temp = temp.Where(m => m.LanguageId == langSrc);
                    }
                }
            }

            if (!String.IsNullOrEmpty(statusSrc) && statusSrc != "any")
            {
                foreach (Status s in (List<Status>)ViewData["Status"])
                {
                    if (s.StatusId == statusSrc)
                    {
                        temp = temp.Where(m => m.Status == statusSrc);
                    }
                }
            }

            if (!String.IsNullOrEmpty(genreSrc))
            {
                string[] genreTemp = genreSrc.Split('*');
                if(genreTemp.Length > 0)
                {
                    foreach(string s in genreTemp)
                    {
                        temp = temp.Where(m => m.Genres.Contains(s));
                    }
                }
            }

            if (!String.IsNullOrEmpty(nameSrc))
            {

            }

            List<Manga> mangas = temp.ToList();

            ViewData["ResultCount"] = mangas.Count;

            switch (sortOpt)
            {
                case "timeDes":
                    {
                        mangas.Sort((x, y) => x.ReleasedYear.CompareTo(y.ReleasedYear));
                        mangas.Reverse();
                        break;
                    }
                case "timeAsc":
                    {
                        mangas.Sort((x, y) => x.ReleasedYear.CompareTo(y.ReleasedYear));
                        break;
                    }
                case "scoreDes":
                    {
                        mangas.Sort((x, y) => Utils.getRatingScore(Utils.getRating(x)).CompareTo(Utils.getRatingScore(Utils.getRating(y))));
                        mangas.Reverse();
                        break;
                    }
                case "scoreAsc":
                    {
                        mangas.Sort((x, y) => Utils.getRatingScore(Utils.getRating(x)).CompareTo(Utils.getRatingScore(Utils.getRating(y))));
                        break;
                    }
                case "followDes":
                    {
                        mangas.Sort((x, y) => Utils.getBookmarkCount(x).CompareTo(Utils.getBookmarkCount(y)));
                        mangas.Reverse();
                        break;
                    }
                case "followAsc":
                    {
                        mangas.Sort((x, y) => Utils.getBookmarkCount(x).CompareTo(Utils.getBookmarkCount(y)));
                        break;
                    }
                default:
                    {
                        mangas.Sort((x, y) => Utils.getRatingScore(Utils.getRating(x)).CompareTo(Utils.getRatingScore(Utils.getRating(y))));
                        mangas.Reverse();
                        break;
                    }
            }

            return View(mangas.ToPagedList(PageNumber, tempPageSize));
        }
    }
}