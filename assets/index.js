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

var syncPreviewScroll = function(){
  // Force scrolling to the bottom if we're very
  // close to the bottom
  if (textbox.scrollHeight - textbox.scrollTop - textbox.clientHeight < 40) {
    preview.scrollTop = preview.scrollHeight - preview.clientHeight;
  } else {
    preview.scrollTop = Math.round(textbox.scrollTop / textbox.scrollHeight * preview.scrollHeight);
  }
};

var syncTextboxScroll = function(){
  if (preview.scrollHeight - preview.scrollTop - preview.clientHeight < 40) {
    textbox.scrollTop = textbox.scrollHeight - textbox.clientHeight;
  } else {
    textbox.scrollTop = Math.round(preview.scrollTop / preview.scrollHeight * textbox.scrollHeight);
  }
};

document.onkeyup = debounce(200, function(){
  var markdown = textbox.value;
  var rendered = marked(markdown);
  preview.innerHTML = rendered;
  highlight();
  syncPreviewScroll();
});

var enableTextboxOnscroll = debounce(200, function(){
  textbox.onscroll = function(){
    syncPreviewScroll();
    // Turn off preview scroll handler temporarily to
    // prevent onscroll handlers bouncing back and forth
    preview.onscroll = function(){};
    enablePreviewOnscroll();
  };
});

var enablePreviewOnscroll = debounce(200, function(){
  preview.onscroll = function(){
    syncTextboxScroll();
    textbox.onscroll = function(){};
    enableTextboxOnscroll();
  };
});

enableTextboxOnscroll();
enablePreviewOnscroll();

