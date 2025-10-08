# Minimap.gd
extends Control

# --- Configuration for your minimap ---
@export var point_radius: float = 3.0 # Radius of the circles drawn for map points
@export var point_color: Color = Color.WHITE # Color of the map points

# Define the boundaries of your game world.
# This is CRUCIAL for correctly scaling world positions to minimap positions.
# Example: If your game world spans from (0,0) to (1000, 1000)
# Adjust these values to match your actual game world's playable area!
@export var world_rect: Rect2 = Rect2(0, 0, 1000, 1000)

var _map_points # Stores the actual Node2D objects from the group

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get all nodes in the "map_point" group.
	# We cast them to Array[Node2D] assuming your points are Node2D-based
	_map_points = get_tree().get_nodes_in_group("map_point")
	# Request an initial draw of the minimap
	queue_redraw()

# Called every frame (if _process is enabled and not paused)
# Or manually call queue_redraw() when points move or new points are added.
func _process(delta: float) -> void:
	# If your map points can move or new ones can appear/disappear,
	# you'll want to call queue_redraw() regularly to update the minimap.
	# For static points, _ready() is enough.
	_map_points = get_tree().get_nodes_in_group("map_point")
	queue_redraw() # Uncomment this line if your map points move frequently.

func _draw() -> void:

	# Calculate the scale factor from world coordinates to minimap (Control node) coordinates
	var minimap_size = size # The size of this Control node
	var world_scale_x = minimap_size.x / world_rect.size.x
	var world_scale_y = minimap_size.y / world_rect.size.y

	# Draw a background for the minimap (optional)
	draw_rect(Rect2(Vector2.ZERO, minimap_size), Color(0.1, 0.1, 0.1, 0.8), true)


	for point_node in _map_points:
		if not is_instance_valid(point_node):
			# If a point node has been freed, refresh the list next update
			# (or immediately if you don't call queue_redraw() every frame)
			continue

		# Get the point's position in the game world
		var world_position = point_node.global_position

		# --- Transform world position to minimap local position ---
		# 1. Offset by the world_rect's origin (to make (0,0) relative to world_rect.position)
		# 2. Scale by the calculated world_scale
		var local_minimap_x = (world_position.x - world_rect.position.x) * world_scale_x
		var local_minimap_y = (world_position.y - world_rect.position.y) * world_scale_y

		var minimap_local_position = Vector2(local_minimap_x, local_minimap_y)

		# Draw the circle on the minimap
		draw_circle(minimap_local_position, point_radius, point_node.point_color)

	# --- Optional: Draw the player's position (example) ---
	# If you have a player node, you can draw it separately, e.g., with a different color/shape.
	# Replace "Player" with the actual name or group of your player node
	var player_node: Node2D = get_tree().get_first_node_in_group("player")
	if player_node and is_instance_valid(player_node):
		var player_world_pos = player_node.global_position
		var player_minimap_x = (player_world_pos.x - world_rect.position.x) * world_scale_x
		var player_minimap_y = (player_world_pos.y - world_rect.position.y) * world_scale_y
		draw_circle(Vector2(player_minimap_x, player_minimap_y), point_radius * 1.5, Color.RED)
		# You could also draw a small rect for player:
		# draw_rect(Rect2(player_minimap_x - 2, player_minimap_y - 2, 4, 4), Color.RED, true)
