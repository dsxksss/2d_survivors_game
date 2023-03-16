extends Node

# 技能触发范围
const MAX_RANGE = 150

@export var sword_ability:PackedScene

func _ready():
	$Timer.timeout.connect(on_timer_timeout)

func on_timer_timeout():
	# 获取玩家node
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	# 获取敌人node组
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	# 过滤掉不在玩家范围150内的敌人
	enemies = enemies.filter(
		func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(
			player.global_position) < pow(MAX_RANGE,2
		)
	)
	
	if enemies.size() <= 0:
		return
	
	# 给敌人组排序，按照距离玩家越近的敌人升序
	enemies.sort_custom(func(a:Node2D,b:Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
		
	var sword_instance = sword_ability.instantiate() as Node2D
	player.get_parent().add_child(sword_instance)
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
