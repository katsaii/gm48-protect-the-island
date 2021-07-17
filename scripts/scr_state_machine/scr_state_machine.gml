/* Push-Down Automata State Machine
 * --------------------------------
 * Kat @katsaii
 */

/// @desc Represents a state machine with a single memory for returning to the previous state.
function StateMachine() constructor {
	stateScript = undefined;
	stateName = undefined;
	lastStateName = stateName;
	step = 0;
	states = { };
	/// @desc Adds a new state to the state machine.
	/// @param {string} name The name of the state.
	/// @param {method} script The id of the script to call.
	static add = function(_name, _state) {
		if not (is_string(_name)) {
			_name = string(_name);
		}
		if not (is_method(_state) || is_real(_state) && script_exists(_state)) {
			_state = undefined;
		}
		states[$ _name] = _state;
		return self;
	}
	/// @desc Runs the current state of the state machine.
	static run = function() {
		if (stateScript != undefined) {
			stateScript(self);
		}
		step += 1;
	}
	/// @desc Sets the state of the automaton.
	/// @param {string} name The name of the state.
	static next = function(_name) {
		lastStateName = stateName;
		stateName = _name;
		if (variable_struct_exists(states, _name)) {
			stateScript = states[$ _name];
		} else {
			stateScript = undefined;
		}
		step = 0;
	}
	/// @desc Sets the state of the automaton to the previously visited state.
	static prev = function() {
		next(lastStateName);
	}
}