namespace MangaWorld_Client.Models
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Genre")]
    public partial class Genre
    {
        [StringLength(40)]
        public string GenreId { get; set; }

        public string GenreDescription { get; set; }

        public byte GenreLevel { get; set; }
    }
}
