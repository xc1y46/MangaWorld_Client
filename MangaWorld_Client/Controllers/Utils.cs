using System;
using System.Collections.Generic;
using System.Linq;
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

        public static Chapter getLastChapters(Manga manga)
        {
            ContextModel db = new ContextModel();

            var temp = db.Chapter.AsNoTracking().Where(c => c.MangaId == manga.MangaId).OrderByDescending(c => c.ChapterOrder).ToList();

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

        public static bool SessionChecking()
        {
            return (
                HttpContext.Current != null &&
                HttpContext.Current.Session != null &&
                HttpContext.Current.Session["Username"] != null
                );
        }
    }
}