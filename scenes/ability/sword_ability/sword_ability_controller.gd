extends Node
# 剑场景
@export var sword_ability:PackedScene

@onready var timer: Timer = $Timer

# 技能触发范围
const MAX_RANGE = 150
# 生成剑基础时间
var base_wait_time: float
# 基本剑伤害
const BASE_DAMAGE = 10


func _ready():
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
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
			player.global_position) < pow(MAX_RANGE, 2)
	)
	
	if enemies.size() <= 0:
		return
	
	# 给敌人组排序，按照距离玩家越近的敌人升序
	enemies.sort_custom(func(a: Node2D,b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	# 加载剑场景实例
	var sword_instance = sword_ability.instantiate() as SwordAbility
	
	# 将剑场景放置到foreground层
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)
	
	# 指定剑的伤害
	sword_instance.hitbox_component.damage = BASE_DAMAGE
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0,TAU)) * 4
	# 获取敌人方向
	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	
	# 剑生成角度朝向敌人
	sword_instance.rotation = enemy_direction.angle()

func on_ability_upgrade_added(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	# 先判断是否为这个能力
	if upgrade.id != "sword_rate":
		return
	var percent_reduction = current_upgrades["sword_rate"]["quantity"] * .1
	# 缩减生成剑时间
	timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0)
	# 因为时间触发会一直执行，所以得重置一下时间设置
	# 如果 time_sec > 0，则会将 wait_time 设置为 time_sec。
	# 这也会将剩余时间重置为 wait_time。
	timer.start()
