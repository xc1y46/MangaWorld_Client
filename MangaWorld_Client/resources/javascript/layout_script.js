/*const { type } = require("jquery");*/

$(document).ready(function () {
    $('#nav-side-toggler').click(function () {
        if ($('.nav-side-bar').width() > 0) {
            $('.nav-side-bar').width(0);
            $('.main-content').css("margin-left", 0);
        } else {
            $('.nav-side-bar').width('14%');
            $('.main-content').css("margin-left", "10%");
        }
    });
    $('#dark-mode-toggler').click(function () {
        document.body.classList.toggle("change-theme");
    });

    $(window).scroll(function () {
        var sticky = $('.layout-head'),
            scroll = $(window).scrollTop();

        if (scroll > 200) sticky.addClass('fixed');
        else sticky.removeClass('fixed');
    });
});