extends Node

# 生成半径
const SPAWN_RADIUS = 370

@export var besic_enemy_scene: PackedScene

func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# 360°随机位置
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	# 生成敌人的最终位置
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	# 实例化导入的基本敌人场景
	var enemy = besic_enemy_scene.instantiate() as Node2D
	get_parent().add_child(enemy)
	enemy.global_position = spawn_position
