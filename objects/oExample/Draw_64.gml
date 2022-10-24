var _string = @"
GMS 2.3.1 Destructors - Zach Reedy / Juju Adams / Nommiin

Press 1 to destroy struct <a> --> Garbage collects a list
Press 2 to destroy struct <b> --> Executes a callback function
Press 3 to destroy struct <c> --> Executes a callback script

" + (ds_exists(global.listReference, ds_type_list)? "List created by <a> exists" : "List created by <a> doesn't exist");

draw_text(10, 10, _string);
var _t = DtorManager()
draw_text(10, 200, "Manager  Size: " + string( _t.size) );
draw_text(10, 220, "Manager Index: " + string(_t.index) );
var _state = time_source_get_state(_t.step);
switch(_state) {
	case time_source_state_active:  draw_text(10, 240, "Manager TimeSource State: Active"); break;
	case time_source_state_stopped: draw_text(10, 240, "Manager TimeSource State: Stopped"); break;
}
