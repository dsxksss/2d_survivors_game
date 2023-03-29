extends Node

# 技能触发范围
const MAX_RANGE = 150
var base_wait_time
var damage = 5

@export var sword_ability:PackedScene

func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

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

func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	# 先判断是否为这个能力
	if upgrade.id != "sword_rate":
		return
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
	# 缩减生成剑时间
	$Timer.wait_time = base_wait_time * (1 - percent_reduction)
	# 因为时间触发会一直执行，所以得重置一下时间设置
	# 如果 time_sec > 0，则会将 wait_time 设置为 time_sec。
	# 这也会将剩余时间重置为 wait_time。
	$Timer.start()
