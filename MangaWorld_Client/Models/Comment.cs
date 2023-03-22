namespace MangaWorld_Client.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Comment")]
    public partial class Comment
    {
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int UserId { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(200)]
        public string CommentContent { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(40)]
        public string MangaId { get; set; }

        [Key]
        [Column(Order = 3)]
        public DateTime CommentDate { get; set; }

        public virtual Manga Manga { get; set; }

        public virtual User User { get; set; }
    }
}
