extends Control


@onready var host: Button = %host
@onready var line_edit: LineEdit = %LineEdit
@onready var join: Button = %join

@onready var r: Button = %r
@onready var s: Button = %s
@onready var p: Button = %p


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
	%redo.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
	
	
func results(id):
	%redo.show()
	match id:
		player_id:
			$VBoxContainer/winner.text="You WIN!"
			
		0:
			$VBoxContainer/winner.text="Its a TIE!"
			

		_:
			$VBoxContainer/winner.text="You LOSE!"
			


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
	$VBoxContainer/your_choice.text="Your choice: " + value
	%Timer.start()

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
	print("Response:", data)
	match req_type:
		"create_room":
			room_id=data["room_id"]
			player_id=int(data["player_id"])
			%roomnum.text="Room ID: "+str(room_id)
		"join_room":
			room_id=data["room_id"]
			player_id=data["player_id"]
		"get_result":
			if "winner" in data:
				match player_id:
					1:
						other_player_selction=data["player2_move"]
					2:
						other_player_selction=data["player1_move"]
			
				results(int(data["winner"]))
				$VBoxContainer/p2_choice.text="Player 2 choice : "+other_player_selction
				$Timer.stop()
	
	


func _on_host_pressed() -> void:
	create_room()
	%online.hide()

func _on_join_pressed() -> void:
	join_room(line_edit.text)
	%online.hide()


func _on_timer_timeout() -> void:
	get_result(room_id)
