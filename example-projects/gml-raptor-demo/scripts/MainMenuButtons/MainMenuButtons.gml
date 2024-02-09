/*
    button clicks
*/
function startStateDemoButton_click() {
	room_goto(rmPlay);
}

function startRaceDemoButton_click() {
	room_goto(rmRace);
}

function startPlaygroundButton_click() {
	room_goto(rmDevPlayground);
}

function startUiDemoButton_click() {
	room_goto(rmUiDemo);
}

function exitButton_click() {
	EXIT_GAME
}

/*
    hotswap languages
*/
function languageButton_click(sender) {
	LG_hotswap(sender.locale_name);
}

/*
	savegame system
*/
#macro SAVE_FILE_NAME_PLAIN		"demosave_plain.json"
#macro SAVE_FILE_NAME_ENC		"demosave_encrypted.dat"
#macro SAVE_FILE_CRYPT_KEY		"~this.is.any_l0ng_string.used.as-kind-of-salt.to.encrypt.the.data!"


function save_plain_text() {
	savegame_save_game(SAVE_FILE_NAME_PLAIN);
}

function save_encrypted() {
	savegame_save_game(SAVE_FILE_NAME_ENC, SAVE_FILE_CRYPT_KEY);
}

function load_plain_text() {
	savegame_load_game(SAVE_FILE_NAME_PLAIN);
}

function load_encrypted() {
	savegame_load_game(SAVE_FILE_NAME_ENC, SAVE_FILE_CRYPT_KEY);
}



