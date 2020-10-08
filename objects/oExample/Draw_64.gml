var _string = @"
GMS 2.3.1 Destructors - Zach Reedy / Juju Adams / Nommiin

Press 1 to destroy struct <a> --> Garbage collects a list
Press 2 to destroy struct <b> --> Executes a callback function
Press 3 to destroy struct <c> --> Executes a callback script

" + (ds_exists(global.listReference, ds_type_list)? "List created by <a> exists" : "List created by <a> doesn't exist");

draw_text(10, 10, _string);
