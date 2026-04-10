extends CanvasLayer

var children:=[]
var selected=null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Button:
			children.append(child)
			child.pressed.connect(_on_button_pressed.bind(child))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selected:
		for child:Button in children:
			if child != selected:
				child.position.y+=300*delta
			else:
				child.position=child.position.lerp(Vector2(512,300),3*delta)
				child.scale = child.scale.lerp(Vector2(1.5, 1.5), 5 * delta)
			
func _on_button_pressed(button):
	selected=button
