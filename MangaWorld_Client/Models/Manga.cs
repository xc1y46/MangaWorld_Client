namespace MangaWorld_Client.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Manga")]
    public partial class Manga
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Manga()
        {
            Chapter = new HashSet<Chapter>();
            Comment = new HashSet<Comment>();
            Rating = new HashSet<Rating>();
            Report = new HashSet<Report>();
        }

        [StringLength(40)]
        public string MangaId { get; set; }

        [Required]
        [StringLength(255)]
        public string Title { get; set; }

        [StringLength(255)]
        public string AltTitle { get; set; }

        [Required]
        [StringLength(255)]
        public string MangaPath { get; set; }

        public string Summary { get; set; }

        [Required]
        [StringLength(40)]
        public string AuthorId { get; set; }

        public string Genres { get; set; }

        [Required]
        [StringLength(40)]
        public string LanguageId { get; set; }

        [Required]
        [StringLength(40)]
        public string Status { get; set; }

        [Required]
        [StringLength(10)]
        public string ReleasedYear { get; set; }

        public bool IsPublished { get; set; }

        public bool Deleted { get; set; }

        public virtual Author Author { get; set; }

        public virtual Language Language { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Chapter> Chapter { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Comment> Comment { get; set; }

        public virtual Status Status1 { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Rating> Rating { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Report> Report { get; set; }
    }
}
