/*
    short description here
*/

function messageboxButton_click() {
	msg_show_ok_cancel("=main_menu/demo_message/title", "=main_menu/demo_message/text",
		function() {
			msg_show_ok("=main_menu/demo_message/click_title","=main_menu/demo_message/ok_clicked");
		},
		function() {
			msg_show_ok("=main_menu/demo_message/click_title","=main_menu/demo_message/cancel_clicked");
		}
	);
}


function ui_demo_exit_click() {
	room_goto(rmMain);
}

function ui_demo_sizable_window_click() {
	instance_create(0, 0, "ui_windows", DemoAlignmentWindow);
}

function ui_demo_control_tree_click() {
	instance_create(0, 0, "ui_windows", DemoDockingWindow);
}

function ui_demo_control_anchoring_click() {
	instance_create(0, 0, "ui_windows", DemoAnchoringWindow);
}

function ui_demo_login_click() {
	instance_create(0, 0, "ui_windows", DemoLoginWindow);
}