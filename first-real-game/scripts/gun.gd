extends Node2D

const BULLET = preload("res://scenes/bullet.tscn")
@onready var muzzle: Marker2D = $Muzzle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
		
	if Input.is_action_just_pressed("fire"):
		var bullet_instance = BULLET.instantiate()   
		get_tree().root.add_child(bullet_instance)         #added to the game 
		bullet_instance.global_position = muzzle.global_position  #the same rotation as the gun and position
		bullet_instance.rotation = rotation
		
