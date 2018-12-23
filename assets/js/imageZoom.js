function unzoomAllImages() {
    $('.img-zoomable').removeClass('img-zoomed');
}

$('.img-zoomable').click(function(e) {
    let bZoom = true;
    if($( this ).hasClass('img-zoomed')) {
        bZoom = false;
    }

    unzoomAllImages();

    if (bZoom === true) {
        $( this ).toggleClass('img-zoomed');
    }
});