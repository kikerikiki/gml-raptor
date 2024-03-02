/*
    Raptor's default theme.
	
	This script is here for you, so you can see, how you can easily define your own theme:
	Just derive from "UiTheme" and set the colors you want, then add the theme to the UiThemeManager
	by invoking "UI_THEMES.add_theme(new YourTheme());"
	
	D O   N O T   D E L E T E   T H I S   T H E M E !
	It is set/added to the UiThemeManager in the raptor core when the app starts.
	You may adapt the color values in here at will, or simply derive your own theme and just use
	this file as a template. Whatever you do, just do not delete this one here!
*/

function UiDefaultTheme() : UiTheme("default") constructor {

	main	= CI_GLOBAL_MAIN;
	bright	= CI_GLOBAL_BRIGHT;
	dark	= CI_GLOBAL_DARK;
	accent	= CI_GLOBAL_ACCENT;

	white	= CI_GLOBAL_WHITE;
	black	= CI_GLOBAL_BLACK;
	shadow	= CI_GLOBAL_SHADOW;

}

