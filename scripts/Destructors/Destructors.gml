/// GMS 2.3.0 Destructors
/// @author Zach Reedy <DatZach>
/// @author Juju Adams <JujuAdams>
/// @author Torin Freimiller <Nommiin>

#macro dtor dtorInstance()
#macro dtor_track dtor.capture(self)

if (code_is_compiled())
	throw "Destructors do not work with YYC";
if (os_browser != browser_not_a_browser)
	throw "Destructors do not work with HTML5";

enum DtorType {
    Function,
    Script,
    
    List,
    Map,
    Grid,
    Priority,
    Queue,
    Stack,
    Buffer,
    
    Sprite,
    Surface,
    VertexBuffer,
    VertexFormat,
    
    Path,
    AnimCurve,
    Instance
}

function DtorInstance(_reference, _type, _value, _option) constructor {
	reference = ptr(_reference);
	type = _type;
	value = _value;
	option = _option;
}

function DtorManager() constructor {
	tracked = ds_list_create();
	
	static capture = function (_reference) {
		return method({
			tracked: tracked,
			reference: _reference
		}, function(type, value, option) {
			if (is_method(value))
				value = method({}, method_get_index(value));
			if (is_method(option))
				option = method({}, method_get_index(option));
		
			ds_list_add(tracked, new DtorInstance(reference, type, value, option));
			reference.__DtorID = get_timer();
		});
	}
	
	static update = function () {
		for (var i = 0, isize = ds_list_size(tracked); i < isize; ++i) {
			var inst = tracked[| i];
			try {
				var _ = inst.reference.__DtorID;
			}
			catch (ex) {
				switch(inst.type) {
	                case DtorType.Function:		inst.value(inst.option);				break;
	                case DtorType.Script:		script_execute(inst.value, inst.option);break;
                
	                case DtorType.List:			ds_list_destroy(inst.value);			break;
	                case DtorType.Map:			ds_map_destroy(inst.value);				break;
	                case DtorType.Grid:			ds_grid_destroy(inst.value);			break;
	                case DtorType.Priority:		ds_priority_destroy(inst.value);		break;
	                case DtorType.Queue:		ds_queue_destroy(inst.value);			break;
	                case DtorType.Stack:		ds_stack_destroy(inst.value);			break;
	                case DtorType.Buffer:		buffer_delete(inst.value);				break;
                
	                case DtorType.Sprite:		sprite_delete(inst.value);				break;
	                case DtorType.Surface:		surface_free(inst.value);				break;
	                case DtorType.VertexBuffer:	vertex_delete_buffer(inst.value);		break;
	                case DtorType.VertexFormat:	vertex_format_delete(inst.value);		break;
                
	                case DtorType.Path:			path_delete(inst.value);				break;
	                case DtorType.AnimCurve:	animcurve_destroy(inst.value);			break;
	                case DtorType.Instance:		instance_destroy(inst.value);			break;
				}
				
				ds_list_delete(tracked, i--);
				--isize;
			}
		}
	};
}

function dtorInstance() {
	static instance = new DtorManager();
	return instance;
}
