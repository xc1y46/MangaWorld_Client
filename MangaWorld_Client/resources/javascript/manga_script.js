$(document).ready(function () {
    
    $('#manga-rate-btn').on('click', function () {
        if ($('#rate-modal').css('display') == 'none') {
            $('#rate-modal').css('display', 'block');
        } else {
            $('#rate-modal').css('display', 'none');
        }
    });

    $('.rate-close-btn').on('click', function () {
        $('#rate-modal').css('display', 'none');
    });

    $('#rating-input').on('input', function () {
        $(".rate-text").text($('#rating-input').val());
    });
});