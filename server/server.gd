extends Node

var peer = WebSocketMultiplayerPeer.new()
const PORT = 8080 # The port your server will listen on

func _ready():
	# 1. Start the server on your specified port
	var err = peer.create_server(PORT)
	if err != OK:
		print("Failed to start server: ", err)
		return
		
	# 2. Tell Godot to use this peer for multiplayer
	multiplayer.multiplayer_peer = peer
	print("Dedicated WebSocket Server started on port ", PORT)

	# 3. Connect signals to track players
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)

func _process(_delta):
	# Note: High-level multiplayer peers poll automatically, 
	# but keeping a minimal loop allows you to check for custom logic if needed.
	pass

func _on_player_connected(id: int):
	print("Player connected! Network ID: ", id)

func _on_player_disconnected(id: int):
	print("Player disconnected. Network ID: ", id)
	
# rpc ------------------------------------

@rpc("any_peer", "call_local", "reliable")
func send_chat_message(username: String, message: String):
	var sender_id = multiplayer.get_remote_sender_id()
	print("Received chat from %s (%d): %s" % [username, sender_id, message])
	
	# Clean up input slightly to prevent empty messages
	if message.strip_edges() == "": return
	
	# Broadcast the message to ALL connected clients
	receive_chat_broadcast.rpc(username, message)

# Helper function for server-side system messages
func system_broadcast(msg: String):
	receive_chat_broadcast.rpc("SYSTEM", msg)

# Placeholder so the server compiles properly (clients will override this)
@rpc("authority", "call_local", "reliable")
func receive_chat_broadcast(_username: String, _message: String):
	pass
