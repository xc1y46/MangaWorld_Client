$(document).ready(function () {
    var scrollSwitch = false;
    var recentScroll = $('.home-season-scroller');

    window.addEventListener('load', () => {
        self.setInterval(() => {
            if (!scrollSwitch) {
                recentScroll.scrollLeft(recentScroll.scrollLeft() + 1);
                if (recentScroll.scrollLeft() >= recentScroll.width() + 650) {
                    scrollSwitch = true;
                }
            } else {
                recentScroll.scrollLeft(recentScroll.scrollLeft() - 1);
                if (recentScroll.scrollLeft() == 0 ) {
                    scrollSwitch = false;
                }
            }
        }, 15);
    });
});