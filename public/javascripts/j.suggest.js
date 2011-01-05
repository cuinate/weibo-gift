	(function($) {

		$.suggest = function(input, options) {
	
			var $input = $(input).attr("autocomplete", "off");
			var $results;

			var timeout = false;		// hold timeout ID for suggestion results to appear	
			var prevLength = 0;			// last recorded length of $input.val()
			var cache = [];				// cache MRU list
			var cacheSize = 0;			// size of cache in chars (bytes?)
			
			if($.trim($input.val())=='' || $.trim($input.val())=='输入好友名字') $input.val('输入好友名字').css('color','#aaa');
			if( ! options.attachObject )
				options.attachObject = $(document.createElement("ul")).appendTo('body');

			$results = $(options.attachObject);
			$results.addClass(options.resultsClass);
			
			resetPosition();
			$(window)
				.load(resetPosition)		// just in case user is changing size of page while loading
				.resize(resetPosition);

			$input.blur(function() {
				setTimeout(function() { $results.hide() }, 200);
			});
			
			$input.focus(function(){
				if($.trim($(this).val())=='输入好友名字'){
					$(this).val('').css('color','#000');
				}
				/*if($.trim($(this).val())==''){
					displayItems('');//显示热门城市列表
				}*/
			});
			$input.click(function(){
				/*var q=$.trim($(this).val());
				displayItems(q);
				$(this).select();*/
			});
						
			// help IE users if possible
			try {
				$results.bgiframe();
			} catch(e) { }

			$input.keyup(processKey);//
			
			function resetPosition() {
				// requires jquery.dimension plugin
				var offset = $input.offset();
				$results.css({
					top: (offset.top + input.offsetHeight) + 'px',
					left: offset.left + 'px'
				});
			}
			
			
			function processKey(e) {
				
				// handling up/down/escape requires results to be visible
				// handling enter/tab requires that AND a result to be selected
				if ((/27$|38$|40$/.test(e.keyCode) && $results.is(':visible')) ||
					(/^13$|^9$/.test(e.keyCode) && getCurrentResult())) {
		            
		            if (e.preventDefault)
		                e.preventDefault();
					if (e.stopPropagation)
		                e.stopPropagation();

	                e.cancelBubble = true;
	                e.returnValue = false;
				
					switch(e.keyCode) {
	
						case 38: // up
							prevResult();
							break;
				
						case 40: // down
							nextResult();
							break;
						case 13: // return
							selectCurrentResult();
							break;
							
						case 27: //	escape
							$results.hide();
							break;
	
					}
					
				} else if ($input.val().length != prevLength) {

					if (timeout) 
						clearTimeout(timeout);
					timeout = setTimeout(suggest, options.delay);
					prevLength = $input.val().length;
					
				}			
					
				
			}
			
			function suggest() {
			
				var q = $.trim($input.val());
				displayItems(q);
			}		
			function displayItems(items) {
				var html = '';

				for (var i = 0; i < options.source.length; i++) {
					var reg = new RegExp('^' + items + '.*$', 'im');
					if (reg.test(options.source[i])){
						html += '<li rel="' + options.source[i] + '"><a href="#' + i + '"><span>' + options.source[i]+ '</span>' + '</a></li>';
					}
				}
				if (html == '') {
					suggest_tip = '<div class="gray ac_result_tip">对不起，找不到：' + items + '</div>';
				}
				else {
					suggest_tip = '<div class="gray ac_result_tip">' + '选择好友名字</div>';
				}
				html = suggest_tip + '<ul>' + html + '</ul>';
				

				$results.html(html).show();
				$results.children('ul').children('li:first-child').addClass(options.selectClass);
				
				$results.children('ul')
					.children('li')
					.mouseover(function() {
						$results.children('ul').children('li').removeClass(options.selectClass);
						$(this).addClass(options.selectClass);
					})
					.click(function(e) {
						e.preventDefault(); 
						e.stopPropagation();
						selectCurrentResult();
					});
			}
						
			function getCurrentResult() {
			
				if (!$results.is(':visible'))
					return false;
			
				var $currentResult = $results.children('ul').children('li.' + options.selectClass);
				if (!$currentResult.length)
					$currentResult = false;
					
				return $currentResult;

			}
			
			function selectCurrentResult() {
			
				$currentResult = getCurrentResult();
			
				if ($currentResult) {
					//$input.val($currentResult.children('a').html().replace(/<span>.+?<\/span>/i,''));
					$results.hide();
					
					var added_no = jQuery('#friends_added div').length;
					if (added_no == 3 )
					{
						alert("抱歉！容量有限，我们现在只能加三个！谢谢");
						return false;
					}
					var friend_name = $currentResult.children('a').children('span').text();
					var friend_added =	$('<div/>',{
						'class':'firend_selected_div',
						'id'   : friend_name
					})
					.append(friend_name)
					.append($('<img/>', {
					  'style': 'margin-left:3px; margin-top:2px;cursor:pointer;',
					  'class' : 'remove_selected_friends',
			           'src' : '/images/cancel.png',
			           click: function() {
			            var left_no = jQuery('#friends_added div').length;
						var id = $(this).attr("div_id");
						var div_id = "#" + id;
						$(div_id).remove();
						if (left_no == 1)
						{
							$("#friends_content_div").hide('slow');
							$("#tweet_content_div").hide('slow');
						}
			           },
					   'div_id'   : friend_name
			         }));
		
				$("#tweet_content_div").show('slow');
				$("#friends_content_div").show('slow');
				$("#friends_added").append(friend_added);
				

					if( $(options.dataContainer) ) {
						$(options.dataContainer).val($currentResult.attr('rel'));
					}
	
					if (options.onSelect) {
						options.onSelect.apply($input[0]);
					}
				}
			
			}
			
			function nextResult() {
			
				$currentResult = getCurrentResult();
			
				if ($currentResult)
					$currentResult
						.removeClass(options.selectClass)
						.next()
							.addClass(options.selectClass);
				else
					$results.children('ul').children('li:first-child').addClass(options.selectClass);
			
			}
			
			function prevResult() {
			
				$currentResult = getCurrentResult();
			
				if ($currentResult)
					$currentResult
						.removeClass(options.selectClass)
						.prev()
							.addClass(options.selectClass);
				else
					$results.children('ul').children('li:last-child').addClass(options.selectClass);
			
			}
	
		}
		
		$.fn.suggest = function(source, options) {
		
			if (!source)
				return;
		
			options = options || {};
			options.source = source;
			options.hot_list=options.hot_list || [];
			options.delay = options.delay || 0;
			options.resultsClass = options.resultsClass || 'ac_results';
			options.selectClass = options.selectClass || 'ac_over';
			options.matchClass = options.matchClass || 'ac_match';
			options.minchars = options.minchars || 1;
			options.delimiter = options.delimiter || '\n';
			options.onSelect = options.onSelect || false;
			options.dataDelimiter = options.dataDelimiter || '\t';
			options.dataContainer = options.dataContainer || '#SuggestResult';
			options.attachObject = options.attachObject || null;
	
			this.each(function() {
				new $.suggest(this, options);
			});
	
			return this;
			
		};
		
	})(jQuery);