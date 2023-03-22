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

        public static List<Genre> getGenre(Manga manga, ContextModel db)
        {
            List<Genre> genre = new List<Genre>();
            string[] TempGenre = manga.Genres.Split('*');

            foreach (string g in TempGenre)
            {
                Genre temp = db.Genre.Find(g);
                if (temp != null) genre.Add(temp);
            }

            return genre.OrderByDescending(t => t.GenreLevel).ToList();
        }

        public static List<byte> getRating(Manga manga, ContextModel db)
        {
            List<Rating> TempRating = db.Rating.Where(r => r.MangaId == manga.MangaId).ToList();
            List<byte> rating = new List<byte>();

            foreach(Rating r in TempRating)
            {
                rating.Add(r.Score);
            }

            return rating;
        }

        public static int getBookmarkCount(Manga manga, ContextModel db)
        {
            List<User> bookmark = db.User.Where(u => u.Bookmarks.Contains(manga.MangaId)).ToList();
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