extends Node

# 生成半径
const SPAWN_RADIUS = 370

@export var besic_enemy_scene: PackedScene
@export var arena_time_manager: Node
@onready var timer:Timer = $Timer
var base_spawn_time: float = 0

func _ready() -> void:
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func on_timer_timeout():
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# 360°随机位置
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	# 生成敌人的最终位置
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	# 实例化导入的基本敌人场景
	var enemy = besic_enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position

func on_arena_difficulty_increased(arena_difficulty: int):
	var time_offset = (.1 / 12) * arena_difficulty
	time_offset = min(time_offset, .7)
	print(time_offset)
	timer.wait_time = base_spawn_time - time_offset
