function unzoomAll() {
    $('.img-zoomable').removeClass('img-zoomed');
}

$('.img-zoomable').click(function(e) {
    unzoomAll();
    $( this ).toggleClass('img-zoomed');
});