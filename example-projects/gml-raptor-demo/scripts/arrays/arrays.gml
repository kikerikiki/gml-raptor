/*
    Helper functions for arrays
*/

/// @function		array_create_2d(sizex, sizey, initial_value = 0)
/// @description	Create a 2-dimensional array and fill it with a specified initial value
function array_create_2d(sizex, sizey, initial_value = 0) {
	var rv = array_create(sizex);
	for (var i = 0; i < sizex; i++)
		rv[@ i] = array_create(sizey, initial_value);
	return rv;
}

/// @function		array_create_3d(sizex, sizey, sizez, initial_value = 0)
/// @description	Create a 3-dimensional array and fill it with a specified initial value
function array_create_3d(sizex, sizey, sizez, initial_value = 0) {
	var rv = array_create(sizex);
	for (var i = 0; i < sizex; i++) {
		var arr = array_create(sizey);
		rv[@ i] = arr;
		for (var j = 0; j < sizey; j++)
			arr[@ j] = array_create(sizez, initial_value);
	}
	return rv;
}

/// @function		array_clear(array, with_value = undefined)
/// @description	Clear the contents of the array to undefined or a specified default value
/// @param {array} array	The array to clear
/// @returns {array}		Cleaned array (same as input parameter, for chaining)
function array_clear(array, with_value = undefined) {
	var i = 0; repeat(array_length(array)) {
		array[@ i] = with_value;
		i++;
	}
	return array;
}

/// @function		array_shuffle(array)
/// @description	Shuffles the given array, randomizing the position of its items
/// @param {array} array	The array to shuffle
/// @returns {array}		Re-ordered array (same as input parameter, for chaining)
function array_shuffle(array) {
    var len = array_length(array),
        random_index = 0,
        value;

    while(len > 0){
		len--;
        random_index = irandom(len);
        
        value = array[@ len];
        array[len] = array[@ random_index];
        array[@ random_index] = value;
    }

	return array;
}

/// @function		array_contains(array, value)
/// @description	Searches the array for the specified value.
/// @param {array} array	The array to search
/// @param {any} value		The value to find
/// @returns {bool}			True, if value is contained in array, otherwise false
function array_contains(array, value) {
	if (array == undefined)
		return false;
		
	for (var i = 0; i < array_length(array); i++) {
		if (array[@ i] == value)
			return true;
	}
	return false;
}