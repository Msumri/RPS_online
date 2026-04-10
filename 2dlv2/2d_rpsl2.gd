extends Node2D
@onready var host: Button = %host
@onready var line_edit: LineEdit = %LineEdit
@onready var join: Button = %join

var url:="https://rps-193406790892.europe-west1.run.app"
var room_id:=""
var player_id:int
var my_selction:="":
	set(value):
		my_selction=value
		selection_made(value)
var other_player_selction:=""
var req_type:=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer2/redo.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
	
	
func results(id):
	$hand.game_on=false
	$CanvasLayer2/redo.show()
	match id:
		player_id:
			$CanvasLayer/Label.text="You WIN!"
			$win.play()
		0:
			$CanvasLayer/Label.text="Its a TIE!"
			$selection.play()

		_:
			$CanvasLayer/Label.text="You LOSE!"
			$lose.play()


func _on_r_pressed() -> void:
	#Logic.picks(1,"rock")
	my_selction="rock"
func _on_p_pressed() -> void:
	#Logic.picks(1,"paper")
	my_selction="paper"
func _on_s_pressed() -> void:
	#Logic.picks(1,"scissor")
	my_selction="scissors"

func selection_made(value):
	send_move(room_id, player_id, value)
	$Timer.start()

func _on_redo_pressed() -> void:
	get_tree().reload_current_scene()
	

func create_room():
	var path =url+ "/create"
	
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({})
	req_type="create_room"
	%HTTPRequest.request(path, headers, HTTPClient.METHOD_POST, body)
	
func join_room(roomid):
	var path =url+ "/join"
	
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"room_id": roomid
	})
	req_type="join_room"
	%HTTPRequest.request(path, headers, HTTPClient.METHOD_POST, body)
	

func send_move(roomid, playerid, move):
	var path =url+ "/move"
	
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"room_id": roomid,
		"player_id": playerid,
		"move": move
	})
	req_type="send_move"
	%HTTPRequest.request(path, headers, HTTPClient.METHOD_POST, body)
	
func get_result(roomid):
	var path = url+"/result?room_id=" + roomid
	req_type="get_result"
	%HTTPRequest.request(path)
	
	
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var text = body.get_string_from_utf8()
	var data = JSON.parse_string(text)
	match req_type:
		"create_room":
			room_id=data["room_id"]
			player_id=int(data["player_id"])
			%roomnum.text="Room ID: "+str(room_id)
		"join_room":
			room_id=data["room_id"]
			player_id=data["player_id"]
		"get_result":
			match player_id:
				1:
					other_player_selction=data["player2_move"]
				2:
					other_player_selction=data["player1_move"]
			if "winner" in data:
				results(int(data["winner"]))
				$Timer.stop()
	
	print("Response:", data)


func _on_host_pressed() -> void:
	create_room()
	%online.hide()

func _on_join_pressed() -> void:
	join_room(line_edit.text)
	%online.hide()


func _on_timer_timeout() -> void:
	get_result(room_id)
