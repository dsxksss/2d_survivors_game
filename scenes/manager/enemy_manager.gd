extends Node

# 生成半径
const SPAWN_RADIUS = 370

# 基本敌人场景
@export var besic_enemy_scene: PackedScene
# 竞技场时间管理器
@export var arena_time_manager: Node
@onready var timer:Timer = $Timer
# 生成敌人基础时间
var base_spawn_time: float

func _ready() -> void:
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	# 当竞技场难度改变时触发on_arena_difficulty_increased函数
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

func on_timer_timeout():
	# 为了避免时间计算错误，在计算前先重置时间
	timer.start()
	# 获取玩家实例
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	# 360°随机2维向量
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	# 生成敌人的最终位置
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	# 实例化导入的基本敌人场景
	var enemy = besic_enemy_scene.instantiate() as Node2D
	#  敌人生成层
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	# 将敌人放置在角色为中心点的视角外围随机位置
	enemy.global_position = spawn_position

# 当竞技场难度增加时
func on_arena_difficulty_increased(arena_difficulty: int):
	# 时间偏移量
	var time_offset = (.1 / 5) * arena_difficulty
	# 保险写法，取小于0.8的时间及以下为生成敌人的时间间隔
	time_offset = min(time_offset, .8)
	print(time_offset)
	# 将新生成间隔应用至生成器内(基本生成时间-间隔偏移) 
	timer.wait_time = base_spawn_time - time_offset
