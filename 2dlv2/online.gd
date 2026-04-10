extends CanvasLayer
@onready var host: Button = %host
@onready var line_edit: LineEdit = %LineEdit
@onready var join: Button = %join
@onready var http_request: HTTPRequest = %HTTPRequest

var id = ResourceUID.create_id()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	print(id)
func _on_host_pressed() -> void:
	create_room()

func _on_join_pressed() -> void:
	join_room(line_edit.text)
# Called every frame. 'delta' is the elapsed time since the previous frame.
