$(function() {
  $('form[method=get]:not([data-remote])').live('submit', function(event) {
    console.log("Form submit");
    event.preventDefault();
    return $.pjax({
      container: '[data-pjax-container]',
      url: this.action + '?' + $(this).serialize()
    });
  });
});