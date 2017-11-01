    $(function() {
      var $doc = $(document),
          $win = $(window);

      var $intro = $('.intro'),
          $items = $intro.find('.item'),
          itemsLen = $items.length,
          svgs = $intro.find('svg').drawsvg({
            callback: fineIntro,
            easing: 'easeOutQuart'
          }),
          currItem = 0;

	var $accordion  = $('#accordion');

	$accordion.accordion();

      function animateIntro() {
        $items.removeClass('active').eq( currItem++ % itemsLen ).addClass('active').find('svg').drawsvg('animate');
      }

	function fineIntro() {
		$intro.hide();
	}

      animateIntro();
    });
