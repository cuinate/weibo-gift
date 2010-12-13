// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var Vboli = {
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
			
			$("#pic_back_slot_thumb1").hover(function(){
				$("#big_picture").css({'background-color':'#f64677'});
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
	},
	
	flashDialog: function(status, title, body) {
		  		if (status === 'fail') status = 'error';
				  Lbsc2.Flash.add(status, body);
		}
	
}

