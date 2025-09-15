extends Node2D

@export var map: TileMapLayer
@export var player: Player
@onready var player_info: PlayerInfo = $"../PlayerInfo"

const RANGE = 100.0
const TEMPERATURE_THRESHOLD = 2.0
const MAX_TEMPERATURE = 60.0
const MIN_TEMPERATURE = -60.0
const TEMPERATURE_DAMAGE_THRESHOLD = -3.0
const DAMAGE_PER_SECOND = 3.0
var environment_temperature = 0.0

func add_environment_temperature(t):
	if abs(t) > abs(environment_temperature):
		environment_temperature = t

func _process(delta: float) -> void:
	var coords = map.local_to_map(player.position)
	environment_temperature = 0
	var cell = map.get_cell_tile_data(coords)
	if cell:
		if cell.get_custom_data("temperature"):
			add_environment_temperature(cell.get_custom_data("temperature"))
	var temperatures = get_tree().get_nodes_in_group("temperature")
	
	for temp_source in temperatures:
		var distance = player.position.distance_to(temp_source.global_position)
		if distance <= RANGE:
			add_environment_temperature(temp_source.temperature)
			
	var temperature_diff = environment_temperature - player_info.temperature
	player_info.temperature += temperature_diff / 3 * delta # 3 秒
	
	player_info.temperature = clamp(player_info.temperature, MIN_TEMPERATURE, MAX_TEMPERATURE)
	if player_info.temperature < TEMPERATURE_DAMAGE_THRESHOLD:
		player_info.hp -= DAMAGE_PER_SECOND * delta
		player_info.hp = max(0.0, player_info.hp)
