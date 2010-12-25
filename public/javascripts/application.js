// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var Vboli = {
	background_url: "url(../images/background/big/back4.png) ",
	background_pic: "back1.png",
	initializer: function(){
	
			/* ------- creating card steps   -----------------*/
			function card_step_nav(step_now)
			{
				/*
				step_saved = $("#step_saved").attr("step_saved");
				$("#"+ step_saved).attr('class','inactive');
				*/
				$("#step_saved").attr("step_saved",step_now);		
				// caption
				cap_step_saved = $("#cap_step_saved").attr("cap_step_saved");
				$("#"+ cap_step_saved).attr('class','step_caption_off');
				$("#cap_"+ step_now).attr('class','step_caption_on');

				//q_type= $(nav_tab).attr("id");
				var cap_step_now = "cap_" + step_now
				$("#cap_step_saved").attr("cap_step_saved",cap_step_now);

				$.get(
					"/createcard.js",
					{
						step:step_now
					});
			}
			
			$("#get_friends_send").click(function(){
				var card_pic_id = $("#card_pic_id").attr("card_pic_id");
				$.get(
					"/get_friends.js",
					{
						card_pic_id:card_pic_id
					});
		
			});
			$(".friend_profile_img").click(function(){
				var friend_name = $(this).attr("friend_name");
				var friend_id    = $(this).attr("friend_id");
				var friend_added =	$('<div/>',{
					'class':'firend_selected_div',
					'id'   : friend_name
				})
				.append(friend_name)
				.append($('<img/>', {
				  'style': 'margin-left:3px; margin-top:2px;cursor:pointer;',
				  'class' : 'remove_selected_friends',
		           'src' : '/images/del.png',
		           click: function() {
		             	var id = $(this).attr("div_id");
						var div_id = "#" + id;
						$(div_id).remove();
		           },
				   'div_id'   : friend_name
		         }));
	
				/*
				.append($('<a/>',{
					'class': 'remove_selected_friends',
					 'id'   :   friend_name
				}))
				*/
				$("#friend_selected_show_div").show();
				$("#friends_added").append(friend_added);
				
			});
			
			$('.remove_selected_friends').click(function(){
				var id = $("this").attr("id");
				var div_id = "#" + id;
				$('div').remove(div_id);
			});
			$("#step1").click(function(){
				//alert("got you!");
				var step_now = "step1";
				card_step_nav(step_now);
			});
			$("#step2").click(function(){
				//alert("got you!");
				var step_now = "step2";
				card_step_nav(step_now);
			});
			
		    $(".temlate_sel").click(function(){
				var template_id = $(this).attr("id");
				$.get(
					"/createcard.js",
					{
					  temp_id:template_id
					});
			});
			
			$("#submit_card").click(function(){
				var card_pic_id = $("#card_photo_id").attr("card_photo_id");
				var input_text  = $("#card_input_text").val();
				var card_photo_url = $("#card_photo_url").attr("card_photo_url");
				$.get(
					"/card_compose.js",
					{
						card_photo_url	  : card_photo_url,
						input_text 		  : input_text
					});
			});
			
			$("#send_card").click(function(){
				var card_pic_id = $("#card_pic_id").attr("card_pic_id");
				var friends_id = new Array(); 
				$("#friends_added").find('.firend_selected_div').each(function(){
					var friend_id = $(this).attr('id');
					friends_id.push(friend_id);
				});
				$.get(
					"/send_card.json",
					{
						card_pic_id	 	  : card_pic_id,
						friends_id 		  : friends_id
					});
			})
	},
	
	flashDialog: function(status, title, body) {
		  		if (status === 'fail') status = 'error';
				  Lbsc2.Flash.add(status, body);
		}
	
}

