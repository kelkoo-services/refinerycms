$(function() {
<<<<<<< HEAD
  $('.tree .toggle').on('click', function(e) { 
    e.preventDefault(); 
=======
  $('.tree').on('click', '.toggle', function(e) {
    e.preventDefault();
>>>>>>> 2-1-main
    var $li   = $(this).parents('li:first');
    var $icon = $li.find('.icon.toggle');
    var $nested = $li.find('.nested');

    if ($icon.hasClass('expanded')) {
      $icon.removeClass('expanded');
      $nested.slideUp(); 
    }
    else {
      var contentUrl = $nested.data('ajax-content');
      $li.addClass('loading');
      
      $nested.load(contentUrl, function() {
        $nested.find('li:last').addClass('branch_end');
        $icon.addClass('expanded');
        init_tooltips();
        $nested.slideDown(); 
        $li.removeClass('loading');
      });
    }
  });
});
