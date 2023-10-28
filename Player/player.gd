extends CharacterBody2D

@export var MOVE_SPEED: float = 100
@onready var animation_tree = $AnimationTree
@export var starting_direction: Vector2 = Vector2(0,1)
@onready var state_machine = animation_tree.get("parameters/playback")
#parameters/Idle/blend_position

@onready var solar_door_in_range = false
@onready var wind_door_in_range = false
@onready var is_wind_correct = false
@onready var points = 0

@onready var flagSolar = 0
@onready var flagWind = 0


func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(delta):
	
	if(solar_door_in_range):
		solar_door_in_range = false
		DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "start")
		
		
	if(global.is_correct_wind and global.flagWind==0):
		points+=10
		global.is_correct_wind = false
		global.flagWind=1
		$PointsLabel.set_text(str(points))
	
	if(wind_door_in_range):
		wind_door_in_range = false
		DialogueManager.show_example_dialogue_balloon(load("res://wind.dialogue"), "start")
	
	if(global.is_correct_solar and global.flagSolar==0):
		points+=10
		global.is_correct_solar = false
		global.flagSolar=1
		print(points)

	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("up")
	)
	update_animation_parameters(input_direction)
	velocity = input_direction*MOVE_SPEED
	move_and_slide()
	pick_new_state()
	

func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		if(velocity > Vector2.ZERO):
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
		
			
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")


func _on_detection_area_body_entered(body):
	print(global.points)
	if(body.name == "DoorSolar"):
		solar_door_in_range = true
		print("Door Solar")
	if(body.name == "DoorWind"):
		wind_door_in_range = true
		print("Door Wind")

func _on_detection_area_body_exited(body):
	pass # Replace with function body.
