extends Node
class_name GameManager

@export var starting_map: String
@onready var player: CharacterBody2D = $Player

var map: Node2D
var generated_rooms: Array[Vector3i]

func _ready() -> void:
	MetSys.set_save_data()
	goto_map(MetSys.get_full_room_path(starting_map))
	MetSys.room_changed.connect(on_room_changed, CONNECT_DEFERRED)
	# TODO: Set an actual position, based on a "start" node
	player.set_position(Vector2(1000, 1000)) 
	get_script().set_meta(&"singleton", self)

func goto_map(map_path: String):
	var prev_map_position := Vector2i.MAX
	if map:
		# If some map is already loaded (which is true anytime other than the beginning), remember its position and free it.
		prev_map_position = MetSys.get_current_room_instance().get_base_coords()
		map.queue_free()
		map = null
	
	# Load the new map scene.
	map = load(map_path).instantiate()
	add_child(map)
	# Adjust the camera.
	MetSys.get_current_room_instance().adjust_camera_limits($Player/PlayerCamera)
	# Set the current layer to the room's layer.
	MetSys.current_layer = MetSys.get_current_room_instance().get_layer()
	
	# If previous map has existed, teleport the player based on map position difference.
	if prev_map_position != Vector2i.MAX:
		player.position -= Vector2(MetSys.get_current_room_instance().get_base_coords() - prev_map_position) * MetSys.settings.in_game_cell_size
		player.on_enter()


func _physics_process(_delta: float) -> void:
	# Notify MetSys about the player's current position.
	MetSys.set_player_position(player.position)
	

func on_room_changed(target_map: String):
	goto_map(MetSys.get_full_room_path(target_map))
		
static func get_singleton() -> GameManager:
	return (GameManager as Script).get_meta(&"singleton") as GameManager
