/// GMS 2.3.0 Destructors
/// @author Zach Reedy <DatZach>
/// @author Juju Adams <JujuAdams>
/// @author Torin Freimiller <Nommiin>
#macro DTOR_ITER 90
#macro DTOR_DEBUG false

/// @ignore
global.dtorTrack = ds_list_create();
global.dtorSize  = 0;

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

/// @ignore
/// @param {enum.DtorType} type
/// @param {Any} value
/// @param {Any} [options]
/// @param {Any} [reference]
function DtorInstance(_type, _value, _option, _ref) constructor {
	reference = weak_ref_create(_ref);
	type   =   _type;
	value  =  _value;
	option = _option;
}

function dtor(_type, _value, _option, _ref=self) {
	ds_list_add(global.dtorTrack, new DtorInstance(_type, _value, _option, _ref) );
	global.dtorSize = ds_list_size(global.dtorTrack);
}

// Feather disable once GM1043
/// @ignore
global.dtorLoop = time_source_create(time_source_global, 5, time_source_units_frames, function() {
	// Feather disable once GM2017
	static clip = function(_data, _min, _max) 
	{
		if (_data > _max) {return (_min); } else
		if (_data < _min) {return (_max); } 
		return (_data );
	}
	static index = 0;
	var n = global.dtorSize;
	if (n > 0) {
		var _inst = global.dtorTrack[| index];
		// Still alive
		if (weak_ref_alive(_inst.reference) ) {
			index = clip(index + 1, 0, n - 1);
			exit; 
		}
		
		switch(_inst.type) {
		    case DtorType.Function:		_inst.value(_inst.option);					break;
		    case DtorType.Script:		script_execute(_inst.value, _inst.option);	break;
		            
		    case DtorType.List:			ds_list_destroy(_inst.value);		break;
		    case DtorType.Map:			ds_map_destroy(_inst.value);		break;
		    case DtorType.Grid:			ds_grid_destroy(_inst.value);		break;
		    case DtorType.Priority:		ds_priority_destroy(_inst.value);	break;
		    case DtorType.Queue:		ds_queue_destroy(_inst.value);		break;
		    case DtorType.Stack:		ds_stack_destroy(_inst.value);		break;
		    case DtorType.Buffer:		buffer_delete(_inst.value);			break;
			
			case DtorType.Sprite:		sprite_delete(_inst.value);			break;
		    case DtorType.Surface:		surface_free(_inst.value);			break;
		    case DtorType.VertexBuffer:	vertex_delete_buffer(_inst.value);	break;
		    case DtorType.VertexFormat:	vertex_format_delete(_inst.value);	break;
			
		    case DtorType.Path:			path_delete(_inst.value);			break;
		    case DtorType.AnimCurve:	animcurve_destroy(_inst.value);		break;
		    case DtorType.Instance:		instance_destroy(_inst.value);		break;
		}
		
		// Delete entry
		ds_list_delete(global.dtorTrack, index);
		global.dtorSize = ds_list_size(global.dtorTrack); // Update list size
		if (DTOR_DEBUG) show_debug_message("Dtor Deleted " + string(index) );
		// Go back in the loop
		index = max(0, index - 1);
	}
}, [], -1);
time_source_start(global.dtorLoop);