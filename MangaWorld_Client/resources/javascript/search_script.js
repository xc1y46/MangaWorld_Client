$(document).ready(function () {
    var selected = "var(--mainCol)";
    var neutral = "rgb( calc(var(--bg-r) - var(--offset1)), calc(var(--bg-r) - var(--offset1)), calc(var(--bg-r) - var(--offset1)))";

    $(window).on('load',function () {
        var temp = $('#genreSrc').val();
        if (temp.length != 0) {
            var SelectedGenres = $('.search-genre');
            SelectedGenres.each(function () {
                var text = $(this).children("b").text();
                if (temp.search(text) != -1) {
                    $(this).css("background-color", selected);
                }
            });
        }
    });

    $('.search-genre').click(function () {
        $('#genreSrc').val($('#genreSrc').val().replace('**', '*'));
        var curr = $('#genreSrc').val();
        var sel = $(this).children("b");

        if (curr.search(sel.text()) == -1) {
            var temp = curr + '*' + sel.text();
            $('#genreSrc').val(temp);
            $(this).css("background-color", selected);
        }
        else {
            var temp = curr.replace(sel.text(), "");
            $('#genreSrc').val(temp);
            $(this).css("background-color", neutral);
        }
    });

    $('#resetBtn').click(function () {
        $('#genreSrc').val('');
        $('.search-genre').css("background-color", neutral);
    });
});