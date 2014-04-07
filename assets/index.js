var $ = function(selector){
  return document.querySelector(selector);
};
var $$ = function(selector){
  return document.querySelectorAll(selector);
};


marked.setOptions({
  gfm: true,
  tables: true,
  pedantic: false,
  sanitize: false,
  smartLists: true
});

var debounce = function(wait, func, immediate) {
  var timeout;
  return function() {
    var context = this, args = arguments;
    var later = function() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
};

var highlight = function(){
  var blocks = $$('pre code');
  Array.prototype.forEach.call(blocks, hljs.highlightBlock);
};

var textbox = $('.file');
var preview = $('.filePreview');

var resize = function(){
  textbox.style.height = window.getComputedStyle(preview).height;
};

document.onkeyup = debounce(200, function(){
  var markdown = textbox.value;
  var rendered = marked(markdown);
  preview.innerHTML = rendered;
  highlight();
  resize();
});

resize();
