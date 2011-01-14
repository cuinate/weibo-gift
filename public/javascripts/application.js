// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var Vboli = {
	background_url: "url(../images/background/big/back4.png) ",
	background_pic: "back1.png",
	send_card_no  : 3,
	friends_all   :  new Array(),
	color_btn     : 0,
	font_btn      : 0,
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
			
			function color_font_sel_click(){
				var x_position = 0;
				var y_position = 0;
				var font_val = $("#font_sel_value").attr("sel_font");
				var color_val = $("#color_sel_value").attr("sel_color") - 1;
				if (font_val%2 == 0){
					x_position = -382;
				}
				if ( (font_val == 1) || (font_val == 2) ){
					y_position = -1* color_val*45.5;
				}
				else if((font_val == 3) || (font_val ==4)){
					y_position = -1 * (color_val*45.5 + 12*45.5);
							}
				else{
					y_position = -1 * (color_val*45.5 + 24*45.5);
						}
			    var font_png_back_position =x_position + "px " + y_position + "px";
				
				$("#font_demo_div").css('backgroundPosition', font_png_back_position);
				
			}
			$(".color_div").click(function(){
				var color_val= $(this).attr("color_value");
				var color = $(this).attr("color");
				$("#color_sel_value").attr("sel_color", color_val);
				$("#color_sel_value").attr("color_sel_value", color);
				color_font_sel_click();
			});
			
			$(".font_demo_small_div").click(function(){
			var font_val= $(this).attr("font_value");
			var font = $(this).attr("font");
			$("#font_sel_value").attr("sel_font", font_val);
			$("#font_sel_value").attr("font_sel_value", font);
			color_font_sel_click();
		});
		
			
			$("#font_btn_div").click(function(){
				if (Vboli.color_btn == 1) {
					$("#color_sel_div").hide('slow');
					$("#font_sel_div").show('slow');
					Vboli.color_btn = 0;
					Vboli.font_btn = 1;
						return true;
				}
				if (Vboli.font_btn == 1 ){
				    $("#font_sel_div").hide('slow');
					Vboli.font_btn = 0;
					return true;
				}
				if (Vboli.font_btn == 0){
					$("#font_sel_div").show('slow');
					Vboli.font_btn = 1;
						return true;
					
				}
				
			});
			$("#color_btn_div").click(function(){
				if (Vboli.font_btn == 1) {
					$("#font_sel_div").hide('slow');
					$("#color_sel_div").show('slow');
					Vboli.font_btn = 0;
					Vboli.color_btn = 1;
					return false;
				}
				if (Vboli.color_btn == 1 ){
				    $("#color_sel_div").hide('slow');
					Vboli.color_btn = 0;
					return false;
				}
				if (Vboli.color_btn == 0){
					$("#color_sel_div").show('slow');
					Vboli.color_btn = 1;
					return false;
					
				}
				
			});
			$("#get_friends_send").click(function(){
				var card_pic_id = $("#card_pic_id").attr("card_pic_id");
				$.get(
					"/get_friends.js",
					{
						card_pic_id:card_pic_id
					});
		
			});
			$(".friend_profile_img").click(function(){
				var added_no = jQuery('#friends_added div').length;
				if (added_no == 3 )
				{
					alert("抱歉！容量有限，我们现在只能加三个！谢谢");
					return false;
				}
				var friend_name = $(this).attr("friend_name");
				var friend_id    = $(this).attr("friend_id");
				var friend_added =	$('<div/>',{
					'class':'firend_selected_div',
					'id'   : friend_name
				})
				.append(friend_name)
				.append($('<img/>', {
				  'style': 'margin-left:5px; margin-top:0px;cursor:pointer;display:block;float:right;',
				  'class' : 'remove_selected_friends',
		           'src' : '/images/del_friends.png',
		           click: function() {
		             	//Vboli.remove_friends_div();
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
				var temp_which = $("#template_which").attr("which");

				$.get(
					"/createcard.js",
					{
					  temp_id:template_id,
					  temp_which:temp_which
					  
					});
			});

			
			$("#submit_card_div").click(function(){
				var card_pic_id = $("#card_photo_id").attr("card_photo_id");
				var temp_which = $("#template_which").attr("which");
				var input_text = $("#card_input_box").val();
				if (!input_text){
					alert("对你的好友说几句吧！");
					return false;
				}
				if (temp_which == "post" && !card_pic_id  )	{
						alert("你还没有上传照片。");
						return false;	
				}
				
				var card_photo_url = $("#card_photo_url").attr("card_photo_url");
				var temp_which = $("#template_which").attr("which");

				var font = $("#font_sel_value").attr("font_sel_value");
				var color = $("#color_sel_value").attr("color_sel_value");
				$.get("/card_compose.json", {
					card_photo_url: card_photo_url,
					input_text: input_text,
					temp_which: temp_which,
					font      : font,
					color     : color
				}, function(data){					
					$.get("/get_friends.js", {
						card_pic_id: data
					});
				});
			
			});
			
			$("#sending_card_btn").click(function(){
				var card_pic_id = $("#card_pic_id").attr("card_pic_id");
				var friends_id = new Array(); 
				//----- testing code for find -------
				// ----------------------------------
				
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
		},
   remove_friends_div: function ()
			{
				
				
			}
	
}

