extends Area2D

@export var speed: float = 100
var direction: Vector2 = Vector2.ZERO

func _ready():
	rotation = direction.angle()

func _process(delta: float) -> void:
	print("Metek pozicija:", position)
	position += direction * speed * delta

	# Odstrani metek, če je zunaj zaslona
	if not get_viewport_rect().has_point(global_position):
		queue_free()
