$(function() {
  $('form[method=get]:not([data-remote])').live('submit', function(event) {
    console.log("Form submit");
    event.preventDefault();
    var query = $('#query').val();
    return $.pjax({
      timeout: 1000,
      container: '[data-pjax-container]',
      url: this.action + '?' + $(this).serialize(),
      success: function () {
        $('head title').html('RubyGems.org | Search for &ldquo;' + query + '&rdquo;');
      }
    });
  });
});