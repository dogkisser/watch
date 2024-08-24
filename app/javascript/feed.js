function openCurrentMedia() {
    const imgUrl = document.querySelector('#media').firstElementChild.src;
    const md5 = imgUrl.split('/').pop().split('.')[0];
    
    const url = `https://e621.net/posts?md5=${md5}`;
    window.open(url, '_blank');
}

window.addEventListener('beforeunload', e => {
    e.preventDefault();
});

/*
document.addEventListener('visibilitychange', _ => {
    socket.send(tabIsVisible(!document.hidden));
});
*/