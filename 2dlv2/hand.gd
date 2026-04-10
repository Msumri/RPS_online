extends Node2D

var cooldown=0.0
var intrevals:=1.0
var speed=50
var game_on:=true
var selected=null
@export var r: Sprite2D
@export var p: Sprite2D
@export var s: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_on=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_on:
		for child in get_children():
			if child is Sprite2D:
				child.position.x -= speed * delta
				if child.position.x > 596 :
					child.scale = child.scale.lerp(Vector2(1.5, 1.5), 0.5 * delta)
					child.modulate = child.modulate.lerp(
						Color(1, 1, 1, 1),
						0.5 * delta
					)				
				else:
					child.scale = child.scale.lerp(Vector2(1, 1), 0.5 * delta)
					child.modulate = child.modulate.lerp(
						Color(1, 1, 1, 0),
						.5 * delta
					)	
				if child.position.x<300:
					child.position.x=900
	else:
		match $"..".other_player_selction:
			"rock":
				selected=r
			"paper":
				selected=p
			"scissors":
				selected=s
		for child in get_children():
			if child is Sprite2D:
				if child !=selected:
					child.position.y -= 300 * delta
					child.modulate = child.modulate.lerp(
						Color(1, 1, 1, 0),
						.5 * delta
					)	
				else:				
					selected.position=selected.position.lerp(Vector2(512,300),3*delta)
					selected.scale = selected.scale.lerp(Vector2(1.5, 1.5), 5 * delta)
					child.modulate = child.modulate.lerp(
						Color(1, 1, 1, 1),
						1 * delta
					)	
					selected=null
