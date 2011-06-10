$(function() {
  $('form[method=get]:not([data-remote])').live('submit', function(event) {
    event.preventDefault();
    var query = $('#query').val();
    return $.pjax({
      timeout: 1000,
      container: '[data-pjax-container]',
      url: this.action + '?' + $(this).serialize()
    });
  });
});