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
            if (!Utils.optionChecking()) Utils.setOptions();
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
                if (nameSrc.Contains(' '))
                {
                    string[] tempName = nameSrc.Split(' ');
                    foreach(string s in tempName)
                    {
                        if (!String.IsNullOrEmpty(s))
                        {
                            temp = temp.Where(m => m.Title.ToLower().Contains(s.ToLower()) || m.AltTitle.ToLower().Contains(s.ToLower()));
                        }
                    }
                }
                else
                {
                    temp = temp.Where(m => m.Title.ToLower().Contains(nameSrc.ToLower()) || m.AltTitle.ToLower().Contains(nameSrc.ToLower()));
                }
            }

            List<Manga> mangas = temp.ToList();

            ViewData["ResultCount"] = mangas.Count;

            mangas = Utils.sortManga(sortOpt, mangas);

            return View(mangas.ToPagedList(PageNumber, tempPageSize));
        }

        public ActionResult Popular()
        {
            var manga = db.Manga.Where(m => m.IsPublished && !m.Deleted).Include(m => m.Author).Include(m => m.Language).Include(m => m.Status1);
            return View(manga.ToList());
        }

        public void toggle_darkmode()
        {
            if (!Utils.optionChecking()) Utils.setOptions();
            if ((bool)Session["DarkMode"])
            {
                Session["DarkMode"] = false;
            }
            else if (!(bool)Session["DarkMode"])
            {
                Session["DarkMode"] = true;
            }
        }

        public void toggle_pagenum()
        {
            if (!Utils.optionChecking()) Utils.setOptions();
            if ((bool)Session["PageNum"])
            {
                Session["PageNum"] = false;
            }
            else if (!(bool)Session["PageNum"])
            {
                Session["PageNum"] = true;
            }
        }

        public void toggle_pageadjust()
        {
            if (!Utils.optionChecking()) Utils.setOptions();
            if ((bool)Session["PageAdjust"])
            {
                Session["PageAdjust"] = false;
            }
            else if (!(bool)Session["PageAdjust"])
            {
                Session["PageAdjust"] = true;
            }
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