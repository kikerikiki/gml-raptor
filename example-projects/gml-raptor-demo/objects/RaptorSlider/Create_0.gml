/// @description DOCS inside!

/*
	A note on the on_value_changed callback:
	This function receives two parameters: new_value, old_value
	so you can always see, which value has been active before the change, in case you need it.
	
	There is also a variable value_percent available which holds the percentage_of_max of the current value.
	The value_percent ranges from 0 to 1, so for display you should multiply it by 100.
*/

#macro __SLIDER_IN_FOCUS		global.__slider_in_focus
__SLIDER_IN_FOCUS				= undefined;

enum slider_autotext {
	none = 0,
	text_is_value = 1,
	text_is_percent = 2
}

enum slider_text {
	h_above = 1,
	h_below = 2,
	v_left  = 4,
	v_right = 8
}

var w = (startup_width  >= 0 ? startup_width  : sprite_width);
var h = (startup_height >= 0 ? startup_height : sprite_height);
sprite_index = orientation_horizontal ?
	if_null(rail_sprite_horizontal, sprite_index) :
	if_null(rail_sprite_vertical, sprite_index);
scale_sprite_to(w, h);

__text_dims = scribble_measure_text(string(max_value));
if (orientation_horizontal)
	text_yoffset += (auto_text_position == slider_text.h_below ? sprite_height : -sprite_height);
else 
	text_xoffset += (auto_text_position == slider_text.v_right ? sprite_width : -__text_dims.x);

event_inherited();

override(RaptorSlider, "a", function() {
	ilog($"--- slider a, now calling base");
	_baseControl_a();
});
a();
_baseControl_a();


value_percent			= 0;

__knob_dims				= new SpriteDim(knob_sprite);
__knob_x				= 0;
__knob_y				= 0;
__knob_min_x			= 0;
__knob_max_x			= 0;
__knob_min_y			= 0;
__knob_max_y			= 0;
__knob_need_calc		= true;
__mouse_over_knob		= false;
__knob_grabbed			= false;
__initial_value_set		= false;
__outside_knob_cursor	= window_get_cursor();
__tilesize				= 0;

xcheck					= CTL_MOUSE_X;
ycheck					= CTL_MOUSE_Y;
__is_topmost			= false;
__over_before			= false;

on_skin_changed = function(_skindata) {
	if (!skinnable) return;
	integrate_skin_data(_skindata);
	__knob_dims = new SpriteDim(knob_sprite);
	update_startup_coordinates();
}

update_client_area = function() {
	if (orientation_horizontal)
		data.__raptordata.client_area.set(0, 0, sprite_width, sprite_height + __text_dims.y);
	else 
		data.__raptordata.client_area.set(0, 0, sprite_width + __text_dims.x, sprite_height);
}

/// @function check_mouse_over_knob()
check_mouse_over_knob = function() {
	xcheck = CTL_MOUSE_X;
	ycheck = CTL_MOUSE_Y;

	__over_before = __mouse_over_knob;
	__is_topmost = is_topmost(xcheck, ycheck);
	
	__mouse_over_knob = __is_topmost &&
		(is_between(xcheck, __knob_x - __knob_dims.origin_x * knob_xscale, __knob_x - __knob_dims.origin_x * knob_xscale + __knob_dims.width  * knob_xscale) &&
		 is_between(ycheck, __knob_y - __knob_dims.origin_y * knob_yscale, __knob_y - __knob_dims.origin_y * knob_yscale + __knob_dims.height * knob_yscale));

	if (__mouse_over_knob != __over_before) {
		if (__mouse_over_knob) {
			if (on_mouse_enter_knob != undefined) on_mouse_enter_knob();
		} else {
			if (on_mouse_leave_knob != undefined) on_mouse_leave_knob();
		}
	}
}

/// @function calculate_value_percent()
calculate_value_percent = function() {
	value_percent = (value - min_value) / max_value;
}

/// @function set_value()
set_value = function(new_value) {
	var old_val = value;
	value = clamp(new_value, min_value, max_value);
	calculate_value_percent();
	__knob_need_calc = (value != old_val);
	if (__knob_need_calc) {
		if (auto_text == slider_autotext.text_is_value)		text = string(round(value)); else
		if (auto_text == slider_autotext.text_is_percent)	text = string_format(value_percent * 100,3,0) + "%"; else
		if (auto_text == slider_autotext.none)				text = "";
		
		if (__initial_value_set && on_value_changed != undefined) on_value_changed(value, old_val);
		__initial_value_set = true; // this skips the FIRST value assignment on creation
	}
}

/// @function __set_draw_colors()
__set_draw_colors = function() {
	if (draw_color != draw_color_mouse_over) {
		draw_color_mouse_over = draw_color;
	}
}

__draw_instance = function() {
	__basecontrol_draw_instance();
	
	__set_draw_colors();
	if (__knob_need_calc) {
		__knob_need_calc = false;
		if (orientation_horizontal) {
			__knob_min_x = x + __knob_dims.origin_x + sprite_xoffset + nine_slice_data.left;
			__knob_max_x = __knob_min_x + nine_slice_data.width - __knob_dims.width;
			__tilesize = (nine_slice_data.width - __knob_dims.width) / (max_value - min_value);

			__knob_min_y = y + __knob_dims.origin_y + sprite_yoffset + nine_slice_data.get_center_y() - __knob_dims.center_y;
			__knob_max_y = __knob_min_y;
			__knob_x = floor(__knob_min_x + (value - min_value) * __tilesize) - __knob_dims.origin_x;
			__knob_y = __knob_min_y;
		} else {
			__knob_min_y = y + __knob_dims.origin_y + sprite_yoffset + nine_slice_data.top;
			__knob_max_y = __knob_min_y + nine_slice_data.height - __knob_dims.height;
			__tilesize = (nine_slice_data.height - __knob_dims.height) / (max_value - min_value);
			
			__knob_min_x = x + __knob_dims.origin_x + sprite_xoffset + nine_slice_data.get_center_x() - __knob_dims.center_x;
			__knob_max_x = __knob_min_x;
			__knob_x = __knob_min_x;
			__knob_y = floor(__knob_max_y - (value - min_value) * __tilesize) + __knob_dims.origin_y;
		}
		__knob_x = clamp(__knob_x, __knob_min_x, __knob_max_x);
		__knob_y = clamp(__knob_y, __knob_min_y, __knob_max_y);
	}
	draw_sprite_ext(
		knob_sprite, 0, 
		__knob_x, 
		__knob_y,
		knob_xscale, knob_yscale, 0,
		(__SLIDER_IN_FOCUS == self && (__mouse_over_knob || __knob_grabbed)) ? knob_color_mouse_over : draw_color, 1);
}

// first, clamp the value in case the dev made a config error (like leaving value at 0 while setting min_value to 1)
value = clamp(value, min_value, max_value);
var initval = value;
value++; // just modify the value
set_value(initval);
