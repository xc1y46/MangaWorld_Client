using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace MangaWorld_Client.Models
{
    public partial class ContextModel : DbContext
    {
        public ContextModel()
            : base("name=MangaWorldModel")
        {
        }

        public virtual DbSet<Author> Author { get; set; }
        public virtual DbSet<ChapterType> ChapterType { get; set; }
        public virtual DbSet<Genre> Genre { get; set; }
        public virtual DbSet<Language> Language { get; set; }
        public virtual DbSet<Manga> Manga { get; set; }
        public virtual DbSet<ScanTeam> ScanTeam { get; set; }
        public virtual DbSet<Status> Status { get; set; }
        public virtual DbSet<User> User { get; set; }
        public virtual DbSet<Chapter> Chapter { get; set; }
        public virtual DbSet<Comment> Comment { get; set; }
        public virtual DbSet<Rating> Rating { get; set; }
        public virtual DbSet<Report> Report { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Author>()
                .HasMany(e => e.Manga)
                .WithRequired(e => e.Author)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ChapterType>()
                .HasMany(e => e.Chapter)
                .WithRequired(e => e.ChapterType)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Language>()
                .HasMany(e => e.Manga)
                .WithRequired(e => e.Language)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Language>()
                .HasMany(e => e.ScanTeam)
                .WithRequired(e => e.Language)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Manga>()
                .HasMany(e => e.Chapter)
                .WithRequired(e => e.Manga)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Manga>()
                .HasMany(e => e.Comment)
                .WithRequired(e => e.Manga)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Manga>()
                .HasMany(e => e.Rating)
                .WithRequired(e => e.Manga)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Manga>()
                .HasMany(e => e.Report)
                .WithRequired(e => e.Manga)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<ScanTeam>()
                .HasMany(e => e.Chapter)
                .WithRequired(e => e.ScanTeam)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<Status>()
                .HasMany(e => e.Manga)
                .WithRequired(e => e.Status1)
                .HasForeignKey(e => e.Status)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<User>()
                .HasMany(e => e.Comment)
                .WithRequired(e => e.User)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<User>()
                .HasMany(e => e.Rating)
                .WithRequired(e => e.User)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<User>()
                .HasMany(e => e.Report)
                .WithRequired(e => e.User)
                .WillCascadeOnDelete(false);
        }
    }
}
