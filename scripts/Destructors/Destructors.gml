/// GMS 2.3.0 Destructors
/// @author Zach Reedy <DatZach>
/// @author Juju Adams <JujuAdams>
/// @author Torin Freimiller <Nommiin>

// #macro dtor __Dtor()
// #macro dtor_track dtor.capture(self)

global.__dtor = ds_list_create();
global.__dtor_index = 0;

#macro DTOR_ITER 90

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

function __DtorInstance(_ref, _type, _value, _option) constructor {
	reference = weak_ref_create(_ref);
	type = _type;
	value = _value;
	option = _option;
}

function dtor_track(type, value, option, ref=self) {
	if (!layer_exists("__lyrDestructors") ) layer_script_end(layer_create(41), __dtor_update);
	ds_list_add(global.__dtor, new __DtorInstance(ref, type, value, option) );
}

function __dtor_update() {
    if (event_type == ev_draw) {
		if (!event_number) {
			if (global.__dtor_index++ > DTOR_ITER)
				global.__dtor_index = 0;			
			
			if (global.__dtor_index > 0) exit;
			
			for (var i = 0, isize = ds_list_size(global.__dtor); i < isize; ++i) {
				var inst = global.__dtor[| i];
				
				// Salir rapido
				if (weak_ref_alive(inst.reference) ) continue;
		
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
				
				ds_list_delete(global.__dtor, i);
				show_debug_message("Dtor Deleted " + string(i) );
				
				--isize;
			}		
		}
    }
}

/*
function DtorManager() constructor {
	tracked = [];
	
	static capture = function (_reference) {
		return method({
			tracked: tracked,
			reference: _reference
		}, function(type, value, option) {
			if (is_method(value))
				value = method({}, method_get_index(value));
			if (is_method(option))
				option = method({}, method_get_index(option));
		
			array_push(tracked, new DtorInstance(reference, type, value, option));
		});
	}
	
	static update = function () {
		for (var i = 0, isize = array_length(tracked); i < isize; ++i) {
			var inst = tracked[i];
			if (weak_ref_alive(inst.reference))
				continue;

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
			
			array_delete(tracked, i--, 1);
			--isize;
		}
	};
}

function __Dtor() {
	static instance = new DtorManager();
	
	if (!layer_exists("__lyrDestructors") ) {
		var _layer = layer_create(0);
		layer_script_end(_layer, instance.update);
	}
	
	return instance;
}

*/


