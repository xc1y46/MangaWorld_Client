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
    public class UsersController : Controller
    {
        private ContextModel db = new ContextModel();

        public ActionResult Login()
        {
            return View();
        }

        public ActionResult LoginResult(string username, string password)
        {
            TempData["LoginResult"] = "";
            if (String.IsNullOrEmpty(username) || String.IsNullOrEmpty(password))
            {
                TempData["LoginResult"] = "All fields must not be empty";
                return RedirectToAction("Login", "Users");
            }

            string pw = Utils.HashPW(password);
            User user = db.User.Where(u => !u.Deleted && u.UserName == username && u.UserPassword == pw).FirstOrDefault();

            if (user == null)
            {
                TempData["LoginResult"] = "Login failed";
                return RedirectToAction("Login", "Users");
            }

            Session.Timeout = 360;
            Session["UserId"] = user.UserId;
            Session["UserName"] = user.UserName;
            return RedirectToAction("Index", "Home");
        }

        public ActionResult Register()
        {
            return View();
        }

        public ActionResult RegisterResult(string username, string password)
        {
            TempData["RegisterResult"] = "";
            if (String.IsNullOrEmpty(username) || String.IsNullOrEmpty(password))
            {
                TempData["RegisterResult"] = "All fields must not be empty";
                return RedirectToAction("Register", "Users");
            }

            User temp = db.User.Where(u => !u.Deleted && u.UserName == username).FirstOrDefault();

            if (temp != null)
            {
                TempData["RegisterResult"] = "Username already existed";
                return RedirectToAction("Register", "Users");
            }

            if (ModelState.IsValid)
            {
                User user = new User {
                    UserName = username,
                    UserPassword = Utils.HashPW(password)
                };

                db.User.Add(user);
                db.SaveChanges();
            }

            return RedirectToAction("Login", "Users");
        }

        public ActionResult Logout()
        {
            if (!Utils.userChecking())
            {
                return RedirectToAction("Index", "Home");
            }

            Session.Clear();
            TempData["LoginResult"] = "";
            return RedirectToAction("Login", "Users");
        }

        // GET: Users/Details/5
        public ActionResult Details(string sortOpt, int? PageSize, int? Page)
        {
            if (!Utils.userChecking())
            {
                TempData["LoginResult"] = "";
                return RedirectToAction("Login", "Users");
            }

            int id = (int)Session["UserId"];
            string name = (string)Session["UserName"];

            User user = db.User.Where(u => u.UserId == id && u.UserName == name && !u.Deleted).FirstOrDefault();

            if (user == null)
            {
                return RedirectToAction("Login", "Users");
            }

            int tempPageSize = (PageSize ?? 10);
            int PageNumber = (Page ?? 1);
            ViewData["User"] = user;
            ViewData["CurrSort"] = String.IsNullOrEmpty(sortOpt) ? "scoreDes" : sortOpt;
            List<Manga> mangas = Utils.getUserBookmark(user);
            ViewData["BookmarkCount"] = mangas.Count;

            mangas = Utils.sortManga(sortOpt, mangas);

            return View(mangas.ToPagedList(PageNumber, tempPageSize));
        }

        // GET: Users/Edit/5
        public ActionResult Rating(string mangaId, string ratinginput)
        {
            if (!Utils.userChecking())
            {
                TempData["LoginResult"] = "";
                return RedirectToAction("Login", "Users");
            }

            int userid = (int)Session["UserId"];
            string username = (string)Session["UserName"];

            User user = db.User.Where(u => u.UserId == userid && u.UserName == username && !u.Deleted).FirstOrDefault();

            if (user == null)
            {
                return RedirectToAction("Login", "Users");
            }

            if (ModelState.IsValid)
            {
                Rating rate = db.Rating.Where(r => r.UserId == userid && r.MangaId == mangaId).FirstOrDefault();
                if (rate != null)
                {
                    Rating temp = rate;
                    temp.Score = byte.Parse(ratinginput);
                    db.Entry(temp).State = EntityState.Modified;
                    db.SaveChanges();
                }
                else
                {
                    rate = new Rating {
                        UserId = userid,
                        MangaId = mangaId,
                        Score = byte.Parse(ratinginput)
                    };
                    db.Rating.Add(rate);
                    db.SaveChanges();
                }
            }

            return RedirectToAction("Index", "Mangas", new { mangaId = mangaId });
        }

        public ActionResult Bookmark(string mangaId)
        {
            if (!Utils.userChecking())
            {
                TempData["LoginResult"] = "";
                return RedirectToAction("Login", "Users");
            }

            int userid = (int)Session["UserId"];
            string username = (string)Session["UserName"];

            User user = db.User.Where(u => u.UserId == userid && u.UserName == username && !u.Deleted).FirstOrDefault();

            if (user == null)
            {
                return RedirectToAction("Login", "Users");
            }

            if (ModelState.IsValid)
            {
                if (user.Bookmarks.Contains(mangaId))
                {
                    user.Bookmarks = user.Bookmarks.Replace(mangaId, "");
                    user.Bookmarks = user.Bookmarks.Replace("**", "*");
                    db.Entry(user).State = EntityState.Modified;
                    db.SaveChanges();
                }
                else
                {
                    user.Bookmarks = user.Bookmarks + "*" + mangaId;
                    user.Bookmarks = user.Bookmarks.Replace("**", "*");
                    db.Entry(user).State = EntityState.Modified;
                    db.SaveChanges();
                }
            }

            return RedirectToAction("Index", "Mangas", new { mangaId = mangaId });
        }

        public ActionResult Report(string mangaId)
        {
            if (!Utils.userChecking())
            {
                TempData["LoginResult"] = "";
                return RedirectToAction("Login", "Users");
            }

            Manga manga = db.Manga.Where(m => !m.Deleted && m.IsPublished && m.MangaId == mangaId).FirstOrDefault();

            if(manga == null)
            {
                return RedirectToAction("Index", "Home");
            }

            ViewData["Manga"] = mangaId;

            return View(manga);
        }

        public ActionResult ReportResult(string mangaId, string reportTilte, string reportContent)
        {
            if (!Utils.userChecking())
            {
                TempData["LoginResult"] = "";
                return RedirectToAction("Login", "Users");
            }

            TempData["ReportResult"] = "";
            if (String.IsNullOrEmpty(reportTilte) || String.IsNullOrEmpty(reportContent) || String.IsNullOrEmpty(mangaId))
            {
                TempData["ReportResult"] = "All fields must not be empty";
                return RedirectToAction("Report", "Users", new { mangaId = mangaId });
            }

            if (ModelState.IsValid)
            {
                Report report = new Report
                {
                    UserId = (int)Session["UserId"],
                    MangaId = mangaId,
                    ReportTitle = reportTilte,
                    ReportContent = reportContent,
                    ReportDate = DateTime.Now
                };
                db.Report.Add(report);
                db.SaveChanges();
            }

            return RedirectToAction("Index", "Mangas", new { mangaId = mangaId });
        }

        public ActionResult Comment(string mangaId, string commentContent)
        {
            if (!Utils.userChecking())
            {
                TempData["LoginResult"] = "";
                return RedirectToAction("Login", "Users");
            }

            if (String.IsNullOrEmpty(commentContent))
            {
                return RedirectToAction("Index", "Mangas", new { mangaId = mangaId, commentEnab = true });
            }

            if (String.IsNullOrEmpty(mangaId))
            {
                return RedirectToAction("Index", "Home");
            }

            int userid = (int)Session["UserId"];
            string username = (string)Session["UserName"];

            User user = db.User.Where(u => u.UserId == userid && u.UserName == username && !u.Deleted).FirstOrDefault();

            if (user == null)
            {
                return RedirectToAction("Login", "Users");
            }

            if (ModelState.IsValid)
            {
                Comment comment = new Comment
                {
                    UserId = (int)Session["UserId"],
                    MangaId = mangaId,
                    CommentContent = commentContent,
                    CommentDate = DateTime.Now
                };
                db.Comment.Add(comment);
                db.SaveChanges();
            }

            return RedirectToAction("Index", "Mangas", new { mangaId = mangaId, commentEnab = true });
        }

        public ActionResult DeleteComment(int commentId, string mangaId)
        {
            if (!Utils.userChecking())
            {
                TempData["LoginResult"] = "";
                return RedirectToAction("Login", "Users");
            }

            if (String.IsNullOrEmpty(mangaId))
            {
                return RedirectToAction("Index", "Home");
            }

            int userid = (int)Session["UserId"];
            string username = (string)Session["UserName"];

            User user = db.User.Where(u => u.UserId == userid && u.UserName == username && !u.Deleted).FirstOrDefault();

            if (user == null)
            {
                return RedirectToAction("Login", "Users");
            }

            Comment comment = db.Comment.Where(c => c.CommentId == commentId && c.UserId == userid).FirstOrDefault();

            if (comment == null)
            {
                return RedirectToAction("Index", "Mangas", new { mangaId = mangaId, commentEnab = true });
            }

            db.Comment.Remove(comment);
            db.SaveChanges();

            return RedirectToAction("Index", "Mangas", new { mangaId = mangaId, commentEnab = true });
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
