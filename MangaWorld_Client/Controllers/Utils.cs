using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.Entity;
using System.Web;
using System.Security.Cryptography;
using System.Text;
using MangaWorld_Client.Models;

namespace MangaWorld_Client.Controllers
{
    public static class Utils
    {
        //Rating: 1-5
        //Genre level: 1-3
        //

        private static readonly string _gallery = "http://datve.top/PJ4_TA/gallery";

        public static readonly string _coverArt = "/Art/Cover_Art.png";

        public static string Gallery
        {
            get
            {
                return _gallery;
            }
        }

        public static string CoverArt
        {
            get
            {
                return _coverArt;
            }
        }

        //true if last, false if first
        public static Chapter getLastOrFirstChapters(Manga manga, bool firstOrLast)
        {
            ContextModel db = new ContextModel();

            var temp = db.Chapter.AsNoTracking().Include(c => c.ScanTeam).Where(c => c.MangaId == manga.MangaId).OrderByDescending(c => c.ChapterOrder).ToList();

            if (!firstOrLast) temp.Reverse();

            db.Dispose();

            return temp[0];
        }

        public static List<Genre> getGenre(Manga manga)
        {
            ContextModel db = new ContextModel();
            List<Genre> genre = new List<Genre>();
            string[] TempGenre = manga.Genres.Split('*');

            foreach (string g in TempGenre)
            {
                Genre temp = db.Genre.AsNoTracking().Where(ge => ge.GenreId == g).FirstOrDefault();
                if (temp != null) genre.Add(temp);
            }

            db.Dispose();

            return genre.OrderByDescending(t => t.GenreLevel).ToList();
        }

        public static List<byte> getRating(Manga manga)
        {
            ContextModel db = new ContextModel();
            List<Rating> TempRating = db.Rating.AsNoTracking().Where(r => r.MangaId == manga.MangaId).ToList();
            List<byte> rating = new List<byte>();
            foreach(Rating r in TempRating)
            {
                rating.Add(r.Score);
            }

            db.Dispose();

            return rating;
        }

        public static float getRatingScore(List<byte> ratings)
        {
            float score = 0.0f;
            if (ratings.Count > 0)
            {
                foreach (byte b in ratings)
                {
                    score += b * 1.0f;
                }
                score /= ratings.Count;
            }

            return score;
        }

        public static int getBookmarkCount(Manga manga)
        {
            ContextModel db = new ContextModel();
            List<User> bookmark = db.User.AsNoTracking().Where(u => u.Bookmarks.Contains(manga.MangaId)).ToList();

            db.Dispose();
            return bookmark.Count;
        }

        public static List<Manga> getUserBookmark(User user)
        {
            ContextModel db = new ContextModel();

            var mangas = db.Manga.AsNoTracking().Include(m => m.Status1).Include(m => m.Author).Include(m => m.Comment).Include(m => m.Language).Where(m => !m.Deleted && m.IsPublished && user.Bookmarks.Contains(m.MangaId)).ToList();

            db.Dispose();

            return mangas;
        }

        public static List<Manga> sortManga(string SortOpt, List<Manga> mangas)
        {
            switch (SortOpt)
            {
                case "recentUpdate":
                    {
                        mangas.Sort((x, y) => (Utils.getLastOrFirstChapters(x, true).UploadDate).CompareTo(Utils.getLastOrFirstChapters(y, true).UploadDate));
                        mangas.Reverse();
                        break;
                    }
                case "mostInteract":
                    {
                        mangas.Sort((x, y) => (Utils.getRating(x).Count + x.Comment.Count).CompareTo(Utils.getRating(y).Count + y.Comment.Count));
                        mangas.Reverse();
                        break;
                    }
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

            return mangas;
        }

        public static string HashPW(string pass)
        {
            SHA1Managed sha1 = new SHA1Managed();
            var hash = sha1.ComputeHash(Encoding.UTF8.GetBytes(pass));
            var pw = new StringBuilder(hash.Length * 2);
            foreach (byte b in hash)
            {
                pw.Append(b.ToString("x2"));
            }
            return pw.ToString();
        }

        public static bool userChecking()
        {
            return (
                HttpContext.Current != null &&
                HttpContext.Current.Session != null &&
                HttpContext.Current.Session["UserId"] != null &&
                HttpContext.Current.Session["UserName"] != null
                );
        }

        public static bool optionChecking()
        {
            return (
                HttpContext.Current.Session["DarkMode"] != null &&
                HttpContext.Current.Session["PageNum"] != null &&
                HttpContext.Current.Session["PageAdjust"] != null
                );
        }

        //true if dark, false if light
        public static void setOptions()
        {
            HttpContext.Current.Session["DarkMode"] = true;
            HttpContext.Current.Session["PageNum"] = false;
            HttpContext.Current.Session["PageAdjust"] = false;
        }
    }
}