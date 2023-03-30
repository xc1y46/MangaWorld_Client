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

        // GET: ScanTeams
        public ActionResult Index(string scanId, int? PageSize, int? Page)
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
