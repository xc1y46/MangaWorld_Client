namespace MangaWorld_Client.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Report")]
    public partial class Report
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int UserId { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(100)]
        public string ReportTitle { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(200)]
        public string ReportContent { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(40)]
        public string MangaId { get; set; }

        [Key]
        [Column(Order = 4)]
        public DateTime ReportDate { get; set; }

        [Key]
        [Column(Order = 5)]
        public bool Resolved { get; set; }

        public virtual Manga Manga { get; set; }

        public virtual User User { get; set; }
    }
}
