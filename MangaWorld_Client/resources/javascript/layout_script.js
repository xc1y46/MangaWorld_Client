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

    $(window).scroll(function () {
        var sticky = $('.layout-head'),
            scroll = $(window).scrollTop();

        if (scroll > 170) sticky.addClass('fixed');
        else if(scroll < 100) sticky.removeClass('fixed');
    });

    $('#dark-mode-toggler').on('click', function () {
        $('body').toggleClass('change-theme');
        $.ajax({
            url: "Home/toggle_darkmode",
            async: false,
            data: {},
            success:  {}
        })
    });

    $('#page-size').on('click', function () {
        $('.chapter-img').toggleClass('chapter-img-adjust');
        $.ajax({
            url: "Home/toggle_pageadjust",
            async: false,
            data: {},
            success: {}
        })
    });

    $('#page-num').on('click', function () {
        $('.page-num-display').toggleClass('page-num-enable');
        $.ajax({
            url: "Home/toggle_pagenum",
            async: false,
            data: {},
            success: {}
        })
    });
});