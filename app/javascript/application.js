// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

/** Turbo's dumb-fuck insistence on NEVER EVER visiting a page if given a redirect, is stupid. No DHH, I will not add a header. */
document.addEventListener("turbo:frame-missing", function (event) {
    if (event.detail.response.redirected) {
        event.preventDefault();
        event.detail.visit(event.detail.response);
    }
})