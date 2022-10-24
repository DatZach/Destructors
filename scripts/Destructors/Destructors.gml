/// GMS 2.3.0 Destructors
/// @author Zach Reedy <DatZach>
/// @author Juju Adams <JujuAdams>
/// @author Torin Freimiller <Nommiin>
// Feather ignore all
#macro DTOR_DEBUG false
#macro DTOR_TIME  5

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
function DtorManager() {
	static ins = {
		step: undefined,
		list: ds_list_create(),
		size:  0,
		index: 0,
		add: function(_ins) {
			ds_list_add(list, _ins);
			size++;
		}
	}
	return ins;
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


/// @param {enum.DtorType} type
/// @param {Any} value
/// @param {Any} [options]
/// @param {Any} [reference]
function dtor(_type, _value, _option, _ref=self) {
	static add  = DtorManager().add;
	static time = DtorManager().step;
	var _instance = new DtorInstance(_type, _value, _option, _ref);
	
	// Add to the manager
	add(_instance);
	// Re-start timesource
	if (time_source_get_state(time) == time_source_state_stopped) {time_source_start(time); }
}


// Startup
with (DtorManager() ) {
	step = time_source_create(time_source_global, DTOR_TIME, time_source_units_frames, function() {
		// Feather disable once GM2017
		static clip = function(_data, _min, _max) 
		{
			if (_data > _max) {return (_min); } else
			if (_data < _min) {return (_max); } 
			return (_data );
		}
		if (size > 0) {
			var _inst = list[| index];
			// Still alive
			if (!weak_ref_alive(_inst.reference) ) {
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
					
				ds_list_delete(list, index);
				size = size - 1; // Update list size
				if (size  <= 0) time_source_stop(step);
				if (DTOR_DEBUG) show_debug_message("Dtor Deleted " + string(index) );
				index = index - 1;
				if (index <  0) index = 0;
				//
			}
			else {
				index = index + 1;
				if (index >= size) index = 0;
			}
		}
	}, [], -1);
	time_source_start(step);
}