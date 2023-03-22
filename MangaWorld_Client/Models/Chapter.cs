namespace MangaWorld_Client.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Chapter")]
    public partial class Chapter
    {
        [Key]
        [Column(Order = 0)]
        [StringLength(40)]
        public string MangaId { get; set; }

        [Key]
        [Column(Order = 1)]
        public float ChapterOrder { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(225)]
        public string ChapterTitle { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(40)]
        public string ChapterTypeId { get; set; }

        [Key]
        [Column(Order = 4)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int PageNum { get; set; }

        [StringLength(255)]
        public string ChapterPath { get; set; }

        [Key]
        [Column(Order = 5)]
        public DateTime UploadDate { get; set; }

        [Key]
        [Column(Order = 6)]
        [StringLength(40)]
        public string ScanTeamId { get; set; }

        [Key]
        [Column(Order = 7)]
        public bool IsPublished { get; set; }

        [Key]
        [Column(Order = 8)]
        public bool Deleted { get; set; }

        public virtual ChapterType ChapterType { get; set; }

        public virtual Manga Manga { get; set; }

        public virtual ScanTeam ScanTeam { get; set; }
    }
}
