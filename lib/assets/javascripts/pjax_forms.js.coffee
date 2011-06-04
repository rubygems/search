$ ->
  $('form[method=get]:not([data-remote])').live 'submit', (event) ->
    event.preventDefault()
    $.pjax
      container: '[data-pjax-container]'
      url: this.action + '?' + $(this).serialize()
