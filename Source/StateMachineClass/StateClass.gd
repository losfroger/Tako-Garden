#
# State class, taken from:
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
#
extends Node
class_name State

# Reference to the state machine, to call at the `transitio_to()` method
# The state machine node will set it
var state_machine = null

var state_name: String

# Virtual function, Recieves events from the `unhandled_input()` callback
func handle_input(_event: InputEvent) -> void:
	pass

# Virtual function, corresponds to the `_proncess()` callback
func update(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(_delta: float) -> void:
	pass

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass

func update_data(_msg := {}) -> void:
	pass
