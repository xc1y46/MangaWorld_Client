$(document).ready(function () {
    $('#chapter-nav-list').val('@ViewData["CurrChapOrd"]');

    $('#page-size').click(function () {
        if ($('.chapter-img').hasClass('chapter-img-adjust')) {
            $('.chapter-img').removeClass('chapter-img-adjust');
        } else {
            $('.chapter-img').addClass('chapter-img-adjust');
        }
    });

    $('#page-num').click(function () {
        if ($('.page-num-display').css('display') == "none") {
            $('.page-num-display').css("display", "block");
        } else {
            $('.page-num-display').css("display", "none");
        }
    });
});