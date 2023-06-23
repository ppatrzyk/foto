import PhotoSwipeLightbox from '/photoswipe-v5.3.7/dist/photoswipe-lightbox.esm.js';
import PhotoSwipe from '/photoswipe-v5.3.7/dist/photoswipe.esm.js';

const lightbox = new PhotoSwipeLightbox({
  // may select multiple "galleries"
  gallery: '#gallery--getting-started',

  // Elements within gallery (slides)
  children: 'a',

  // setup PhotoSwipe Core dynamic import
  pswpModule: PhotoSwipe
});
lightbox.init();