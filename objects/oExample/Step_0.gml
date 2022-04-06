// NOTE This is the only line that is required for GC Dtors to work.
//		Should be placed inside of a persistent game controller object
if (keyboard_check_pressed(ord("1"))) {
    show_debug_message("Deleting <a>");
    delete a;
}

if (keyboard_check_pressed(ord("2"))) {
    show_debug_message("Deleting <b>");
    delete b;
}

if (keyboard_check_pressed(ord("3"))) {
    show_debug_message("Deleting <c>");
    delete c;
}

