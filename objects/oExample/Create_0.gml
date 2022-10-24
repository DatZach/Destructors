function test1() constructor {
	static start = function() {
		list = ds_list_create();
		global.listReference = list;
		dtor(DtorType.List, list);
	}
    start();
}

function test2() constructor {
    name = "Jing";
	
	function callback(_parameter) {
        show_message("This callback cannot reference variables defined inside the constructor, but we can take parameters defined when registering the callback:\n\n\""+ string(_parameter) + "\"");
        
        try {
            show_message(name);
        }
        catch(_error) {
            show_message("Here's what happens when you try to read a variable from a GC'd struct in this callback:\n\n\n" + string(_error));
        }
    }
    
    dtor(DtorType.Function, callback, "This is a parameter passed into the function.");
}

function test3() constructor {
    dtor(DtorType.Script, oExample_CallbackScript, "This is a parameter passed into the script.");
}

a = new test1();
b = new test2();
c = new test3();