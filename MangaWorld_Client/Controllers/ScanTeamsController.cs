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
    public class ScanTeamsController : Controller
    {
        private ContextModel db = new ContextModel();

        public ActionResult Index(string teamName, int? PageSize, int? Page, string langSrc)
        {
            int tempPageSize = (PageSize ?? 6);
            int PageNumber = (Page ?? 1);
            ViewData["Language"] = db.Language.ToList();

            ViewData["CurrTeamName"] = (String.IsNullOrEmpty(teamName)) ? "" : teamName;
            ViewData["CurrLang"] = String.IsNullOrEmpty(langSrc) ? "any" : langSrc;

            var scanTeams = db.ScanTeam.Include(c => c.Chapter);

            if (!String.IsNullOrEmpty(langSrc) && langSrc != "any")
            {
                foreach (Language l in (List<Language>)ViewData["Language"])
                {
                    if (l.LanguageId == langSrc)
                    {
                        scanTeams = scanTeams.Where(m => m.LanguageId == langSrc);
                    }
                }
            }

            if (!String.IsNullOrEmpty(teamName))
            {
                scanTeams = scanTeams.Where(s => s.TeamName.ToLower().Contains(teamName.ToLower()));
            }

            return View(scanTeams.OrderByDescending(s => s.Chapter.Count).ToPagedList(PageNumber, tempPageSize));
        }

        // GET: ScanTeams
        public ActionResult Detail(string scanId, int? PageSize, int? Page)
        {
            if (scanId == null)
            {
                return RedirectToAction("Index", "Home");
            }
            ScanTeam scanTeam = db.ScanTeam.Include(s => s.Chapter).Where(s => s.ScanTeamId == scanId).FirstOrDefault();
            if (scanTeam == null)
            {
                return RedirectToAction("Index", "Home");
            }

            int tempPageSize = (PageSize ?? 5);
            int PageNumber = (Page ?? 1);
            ViewData["ScanTeam"] = scanTeam;

            var mangas = db.Manga.Include(m => m.Chapter).Where(m => m.IsPublished && !m.Deleted && m.Chapter.Any(c => c.ScanTeamId == scanId)).OrderByDescending(c => c.ReleasedYear);

            return View(mangas.ToPagedList(PageNumber, tempPageSize));
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
