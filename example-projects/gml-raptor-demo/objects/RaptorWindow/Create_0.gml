/// @description override draw_self (window)

/*
	Rules for the "size direction" variable are like the numpad on keyboard:
	
		7  8  9
		+-----+
		|     |
	  4 |     | 6
		|     |
		+-----+
		1  2  3
	
	if size direction != 0, then odd directions (1,3,7,9) cause the diagonal arrow to appear,
	4 and 6 the horizontal one and 2 and 8 the vertical one
*/

event_inherited();

#macro __WINDOW_RESIZE_BORDER_WIDTH		8

#macro __MOUSE_OVER_FOCUS_WINDOW		(__RAPTOR_FOCUS_WINDOW != undefined && __RAPTOR_FOCUS_WINDOW.mouse_is_over)

#macro __RAPTOR_WINDOW_FOCUS_CHANGE_RUNNING		global.__raptor_window_focus_change_running
#macro __RAPTOR_FOCUS_WINDOW					global.__raptor_focus_window
__RAPTOR_WINDOW_FOCUS_CHANGE_RUNNING	= false;
__RAPTOR_FOCUS_WINDOW					= undefined;

if (window_is_sizable && image_number > 2)
	image_index = 2;

title				= LG_resolve(title);

has_focus			= false;
__can_draw_focus	= image_number > image_index;
__focus_index		= -1;

__last_title		= "";
__title_x			= 0;
__title_y			= 0;
__scribble_title	= undefined;

__x_button			= undefined;
__x_button_closing	= undefined;

__startup_depth		= depth;

__in_drag_mode		= false;
__drag_rect			= new Rectangle();

__size_rect_top		= new Rectangle();
__size_rect_bottom	= new Rectangle();
__size_rect_left	= new Rectangle();
__size_rect_right	= new Rectangle();
__in_size_mode		= false;
__size_direction	= 0;
// _rc = raptor cursor:Image index of the sizable sprite
__size_images_rc	= [-1,3,1,2,0,-1,0,2,1,3];
// _dc = default cursor (gamemaker cr_ constants)
__size_images_dc	= [cr_default,cr_size_nesw,cr_size_ns,cr_size_nwse,cr_size_we,cr_default,cr_size_we,cr_size_nwse,cr_size_ns,cr_size_nesw];

if (window_x_button_visible && !is_null(window_x_button_object)) {
	__x_button = instance_create(0, 0, SELF_LAYER_OR_DEPTH, window_x_button_object);
	//__x_button.depth = depth - 1;
	__x_button.attach_to_window(self);
	__x_button_closing = __x_button.on_left_click;
	__x_button.on_left_click = function(sender) {
		// This is the original left click handler on the x button that might have been set
		// at design time but was overwritten by this function
		if (!is_null(__x_button_closing))
			__x_button_closing(__x_button);
		// Launch the closing callback set on the window
		if (!is_null(on_closing)) 
			on_closing(self);
		close();
	}
}

#region sizable window

__do_sizing = function() {
	var recalc = true;
	switch (__size_direction) {
		case 1:
			scale_sprite_to(max(min_width,sprite_width - CTL_MOUSE_DELTA_X), max(min_height,sprite_height + CTL_MOUSE_DELTA_Y));
			x += CTL_MOUSE_DELTA_X;
			break;
		case 2:
			scale_sprite_to(max(min_width,sprite_width                    ), max(min_height,sprite_height + CTL_MOUSE_DELTA_Y));
			break;
		case 3:
			scale_sprite_to(max(min_width,sprite_width + CTL_MOUSE_DELTA_X), max(min_height,sprite_height + CTL_MOUSE_DELTA_Y));
			break;
		case 4:
			scale_sprite_to(max(min_width,sprite_width - CTL_MOUSE_DELTA_X), max(min_height,sprite_height                    ));
			x += CTL_MOUSE_DELTA_X;
			break;
		case 6:
			scale_sprite_to(max(min_width,sprite_width + CTL_MOUSE_DELTA_X), max(min_height,sprite_height                    ));			
			break;
		case 7:
			scale_sprite_to(max(min_width,sprite_width - CTL_MOUSE_DELTA_X), max(min_height,sprite_height - CTL_MOUSE_DELTA_Y));
			x += CTL_MOUSE_DELTA_X;
			y += CTL_MOUSE_DELTA_Y;
			break;
		case 8:
			scale_sprite_to(max(min_width,sprite_width                    ), max(min_height,sprite_height - CTL_MOUSE_DELTA_Y));
			y += CTL_MOUSE_DELTA_Y;
			break;
		case 9:
			scale_sprite_to(max(min_width,sprite_width + CTL_MOUSE_DELTA_X), max(min_height,sprite_height - CTL_MOUSE_DELTA_Y));
			y += CTL_MOUSE_DELTA_Y;
			break;
		default:
			recalc = false;
			break;
	}
	if (recalc) {
		__startup_xscale = image_xscale;
		__startup_yscale = image_yscale;
		__setup_drag_rect();
		control_tree.layout();
	}
}

// Find the windows' sizing areas
// we need to check all 4 borders and in each of them the adjacent sides to find the diagonals
__find_sizing_area = function() {
	if (!has_focus) return;
	if (__size_rect_top.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) {
		
		if (__size_rect_left.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) __size_direction = 7;
		else if (__size_rect_right.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) __size_direction = 9;
		else
			__size_direction = 8;
			
	} else if (__size_rect_bottom.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) {
		
		if (__size_rect_left.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) __size_direction = 1;
		else if (__size_rect_right.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) __size_direction = 3;
		else 
			__size_direction = 2;
		
	} else if (__size_rect_left.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) {
		
		if (__size_rect_top.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) __size_direction = 7;
		else if (__size_rect_bottom.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) __size_direction = 1;
		else
			__size_direction = 4;

	} else if (__size_rect_right.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) {

		if (__size_rect_top.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) __size_direction = 9;
		else if (__size_rect_bottom.intersects_point(CTL_MOUSE_X, CTL_MOUSE_Y)) __size_direction = 3;
		else
			__size_direction = 6;

	} else
		__size_direction = 0;
	
	__set_sizing_cursor();
}

__set_sizing_cursor = function() {
	if (!has_focus) return;
	if (MOUSE_CURSOR != undefined)
		if (__size_direction == 0)
			MOUSE_CURSOR.set_cursor(mouse_cursor_type.pointer);
		else
			MOUSE_CURSOR.set_cursor(mouse_cursor_type.sizing, __size_images_rc[@__size_direction]);
	else
		window_set_cursor(__size_images_dc[@__size_direction]);
}

/// @function				__setup_drag_rect(ninetop)
/// @description			setup drag and resize rects
/// @param {int} ninetop
__setup_drag_rect = function() {
	var size_offset = (window_is_sizable ? __WINDOW_RESIZE_BORDER_WIDTH : 0);
	__drag_rect.set(
		SELF_VIEW_LEFT_EDGE + size_offset, 
		SELF_VIEW_TOP_EDGE + size_offset, 
		SELF_WIDTH - 2 * size_offset, 
		titlebar_height
	);
	
	__size_rect_top.set(
		SELF_VIEW_LEFT_EDGE, 
		SELF_VIEW_TOP_EDGE, 
		SELF_WIDTH, 
		__WINDOW_RESIZE_BORDER_WIDTH
	);
	
	__size_rect_bottom.set(
		SELF_VIEW_LEFT_EDGE, 
		SELF_VIEW_BOTTOM_EDGE - __WINDOW_RESIZE_BORDER_WIDTH,
		SELF_WIDTH, 
		__WINDOW_RESIZE_BORDER_WIDTH
	);

	__size_rect_left.set(
		SELF_VIEW_LEFT_EDGE,
		SELF_VIEW_TOP_EDGE,
		__WINDOW_RESIZE_BORDER_WIDTH,
		SELF_HEIGHT
	);

	__size_rect_right.set(
		SELF_VIEW_RIGHT_EDGE - __WINDOW_RESIZE_BORDER_WIDTH,
		SELF_VIEW_TOP_EDGE,
		__WINDOW_RESIZE_BORDER_WIDTH,
		SELF_HEIGHT
	);
}

#endregion

#region focus chain

__focus_next_in_chain = function() {
	var win = undefined;
	var maxidx = -1;
	with(RaptorWindow) {
		if (!eq(self, other) && __focus_index > maxidx) {
			maxidx = __focus_index;
			win = self;
		}
	}
	if (maxidx > -1 && win != undefined)
		with(win) take_focus();
}

__reorder_focus_index = function(_old_idx) {
	with(RaptorWindow) {
		if (!eq(self, other) && __focus_index > _old_idx)
			__focus_index--;
	}
	// to avoid a (theoretically possible) endless loop here,
	// we stop after n iterations, where n = instance_number(RaptorWindow)
	var maxiter = instance_number(RaptorWindow);
	var curiter = 0;
	var have_doubles = true;
	while (have_doubles) {
		var seen = [];
		have_doubles = false;
		with(RaptorWindow) {
			if (!array_contains(seen, __focus_index))
				array_push(seen, __focus_index);
			else {
				have_doubles = true;
				__focus_index--;
			}
		}
		// exit after n iterations
		if (++curiter == maxiter)
			break;
	}
	// last step: set the depth of the windows
	with(RaptorWindow) {
		depth = __startup_depth - 1 - 2 * __focus_index;
	}
	// -- debug output --
	//vlog($"--- FOCUS INDEX REPORT ---");
	//with(RaptorWindow)
	//	vlog($"--- {__focus_index}: {MY_NAME}{(eq(self,other) ? " ** SELF **" : "")}");
}

lose_focus = function() {
	has_focus = false;
}

take_focus = function(_only_if_topmost = false) {
	if (__RAPTOR_WINDOW_FOCUS_CHANGE_RUNNING) 
		return;
	
	if (_only_if_topmost) {
		var allwins = ds_list_create();
		if (instance_position_list(CTL_MOUSE_X, CTL_MOUSE_Y, RaptorWindow, allwins, false) > 1) {
			var mindepth = DEPTH_BOTTOM_MOST;
			for (var i = 0, len = ds_list_size(allwins); i < len; i++) {
				var w = allwins[|i];
				if (w.has_focus) continue;
				mindepth = min(mindepth, w.depth);
			}
			ds_list_destroy(allwins);
			if (mindepth != depth)
				return;
		}
	}
	
	vlog($"Window {MY_NAME} taking focus");
	__RAPTOR_WINDOW_FOCUS_CHANGE_RUNNING = true;
	
	with(RaptorWindow) lose_focus();
	has_focus = true;
	__RAPTOR_FOCUS_WINDOW = self;
	var maxidx = instance_number(RaptorWindow) - 1;
	var myidx = (__focus_index >= 0 ? __focus_index : maxidx);
	__focus_index = maxidx;
	__reorder_focus_index(myidx);
	// this mouse_is_over check is for the case, that a popup (like a MessageBox)
	// was visible on top of self. due to HIDDEN_BEHIND_POPUP, self would not register
	// a mouse_enter when the popup closes. This corrects the bool.
	mouse_is_over = instance_position(CTL_MOUSE_X, CTL_MOUSE_Y, self);
	__RAPTOR_WINDOW_FOCUS_CHANGE_RUNNING = false;
}
take_focus(); // we take focus on creation

#endregion

close = function() {
	control_tree.invoke_on_closed();
	instance_destroy(self);
}

/// @function					scribble_add_title_effects(titletext)
/// @description				called when a scribble element is created to allow adding custom effects.
///								overwrite (redefine) in child controls
/// @param {struct} titletext
scribble_add_title_effects = function(titletext) {
	// example: titletext.blend(c_blue, 1); // where ,1 is alpha
}

__update_client_area = function() {
	data.client_area.set(
		__WINDOW_RESIZE_BORDER_WIDTH, 
		titlebar_height + __WINDOW_RESIZE_BORDER_WIDTH / 2, 
		sprite_width - 2 * __WINDOW_RESIZE_BORDER_WIDTH,
		sprite_height - titlebar_height - 1.5 * __WINDOW_RESIZE_BORDER_WIDTH);
}

/// @function					__create_scribble_title_object(align, str)
/// @description				setup the initial object to work with
/// @param {string} align			
/// @param {string} str			
__create_scribble_title_object = function(align, str) {
	return scribble($"{align}{str}", MY_NAME)
			.starting_format(font_to_use == "undefined" ? scribble_font_get_default() : font_to_use, 
				mouse_is_over ? title_color_mouse_over : title_color);
}

/// @function					__draw_self()
/// @description				invoked from draw or drawGui
__draw_self = function() {
	if (__CONTROL_NEEDS_LAYOUT || __last_title != title) {
		__force_redraw = false;

		__scribble_text = __create_scribble_object(scribble_text_align, text);
		scribble_add_text_effects(__scribble_text);

		__scribble_title = __create_scribble_title_object(scribble_title_align, title);
		scribble_add_title_effects(__scribble_title);
		
		var nineleft = 0, nineright = 0, ninetop = 0, ninebottom = 0, distx = 0, disty = 0;
		var nine = -1;
		if (sprite_index != -1) {
			nine = sprite_get_nineslice(sprite_index);
			if (nine != -1) {
				nineleft = nine.left;
				nineright = nine.right;
				ninetop = nine.top;
				ninebottom = nine.bottom;
			}

			distx = nineleft + nineright;
			disty = ninetop + ninebottom;
			image_xscale = max(__startup_xscale, (max(min_width, max(__scribble_text.get_width(),  __scribble_title.get_width()))  + distx) / sprite_get_width(sprite_index));
			image_yscale = max(__startup_yscale, (max(min_height,max(__scribble_text.get_height(), __scribble_title.get_height())) + disty) / sprite_get_height(sprite_index));

			__setup_drag_rect();
			edges.update(nine);
			nine_slice_data.set(nineleft, ninetop, sprite_width - distx, sprite_height - disty);
		} else {
			// No sprite - update edges by hand
			edges.left = x;
			edges.top = y;
			edges.width  = text != "" ? __scribble_text.get_width() : 0;
			edges.height = text != "" ? __scribble_text.get_height() : 0;
			edges.right = edges.left + edges.width - 1;
			edges.bottom = edges.top + edges.height - 1;
			edges.center_x = x + edges.width / 2;
			edges.center_y = y + edges.height / 2;
			edges.copy_to_nineslice();
		}
		
		__text_x = edges.ninesliced.center_x + text_xoffset;
		__text_y = edges.ninesliced.center_y + text_yoffset;
		// text offset behaves differently when right or bottom aligned
		if      (string_pos("[fa_left]",   scribble_text_align) != 0) __text_x = edges.ninesliced.left   + text_xoffset;
		else if (string_pos("[fa_right]",  scribble_text_align) != 0) __text_x = edges.ninesliced.right  - text_xoffset;
		if      (string_pos("[fa_top]",    scribble_text_align) != 0) __text_y = edges.ninesliced.top    + text_yoffset;
		else if (string_pos("[fa_bottom]", scribble_text_align) != 0) __text_y = edges.ninesliced.bottom - text_yoffset;

		__title_x = SELF_VIEW_CENTER_X + title_xoffset;
		__title_y = SELF_VIEW_TOP_EDGE + titlebar_height / 2 + title_yoffset; // title aligned to titlebar_height by default
		// title offset behaves differently when right or bottom aligned
		if      (string_pos("[fa_left]",   scribble_title_align) != 0) __title_x = edges.ninesliced.left   + title_xoffset;
		else if (string_pos("[fa_right]",  scribble_title_align) != 0) __title_x = edges.ninesliced.right  - title_xoffset;
		if      (string_pos("[fa_top]",    scribble_title_align) != 0) __title_y = SELF_VIEW_TOP_EDGE      + title_yoffset;
		else if (string_pos("[fa_bottom]", scribble_title_align) != 0) __title_y = titlebar_height         - title_yoffset;

		__last_text				= text;
		__last_sprite_index		= sprite_index;
		__last_sprite_width		= sprite_width;
		__last_sprite_height	= sprite_height;
		__last_title			= title;
		
		__update_client_area();		
	}

	if (__CONTROL_DRAWS_SELF)
		__draw_instance();
}

__draw_instance = function() {
	
	if (control_tree != undefined) {
		if (__first_draw) {
			control_tree.layout();
		}

		if (sprite_index != -1) {
			image_blend = draw_color;
			draw_self();
			image_blend = c_white;
			if (has_focus && __can_draw_focus)
				draw_sprite_ext(sprite_index, image_index + 1, x, y, image_xscale, image_yscale, image_angle, focus_border_color, image_alpha);
			if (!is_null(__x_button)) with(__x_button) __draw_self();
		}
	
		if (text  != "") __scribble_text .draw(__text_x,  __text_y );
		if (title != "") __scribble_title.draw(__title_x, __title_y);

		control_tree.draw_children();
	
		if (__first_draw) {
			__first_draw = false;
			control_tree.invoke_on_opened();
		}
	}
	
	// this code draws the client area in red, if one day there's a bug with alignment
	draw_set_color(c_red);
	draw_rectangle(x+data.client_area.left, y+data.client_area.top, x+data.client_area.get_right(), y+data.client_area.get_bottom(), true);
	draw_set_color(c_white);
}