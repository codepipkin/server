extends Node

var peer = WebSocketMultiplayerPeer.new()

func _ready():
	# Default to 8080 locally, but read Railway's dynamic variable if it exists
	var port = 8080
	if OS.has_environment("PORT"):
		port = OS.get_environment("PORT").to_int()

	var err = peer.create_server(port)
	if err != OK:
		print("Failed to start server: ", err)
		return
		
	multiplayer.multiplayer_peer = peer
	print("Dedicated Chat Server successfully started on port: ", port)


func _process(_delta):
	# Note: High-level multiplayer peers poll automatically, 
	# but keeping a minimal loop allows you to check for custom logic if needed.
	pass

func _on_player_connected(id: int):
	print("Player connected! Network ID: ", id)

func _on_player_disconnected(id: int):
	print("Player disconnected. Network ID: ", id)
	system_broadcast("[color=cyan]« now leaving [A][/color]" + ": " + "pipkin")
	
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
	receive_chat_broadcast.rpc("yapper_chan", msg)



# Placeholder so the server compiles properly (clients will override this)
@rpc("authority", "call_local", "reliable")
func receive_chat_broadcast(_username: String, _message: String):
	pass
