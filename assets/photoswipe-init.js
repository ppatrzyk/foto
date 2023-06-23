import PhotoSwipeLightbox from '/photoswipe-v5.3.7/dist/photoswipe-lightbox.esm.js';
import PhotoSwipe from '/photoswipe-v5.3.7/dist/photoswipe.esm.js';

const lightbox = new PhotoSwipeLightbox({
  gallery: '#mygallery',
  children: 'a',
  pswpModule: PhotoSwipe,
  bgOpacity: 0.5,
  spacing: 0.1,
  padding: { top: 20, bottom: 20, left: 100, right: 100 },
});
lightbox.init();