extends Node

# 难度递增信号
signal arena_difficulty_increased(arena_difficulty: int)

# 难度升级时间间隔(秒)
const DIFFICULTY_INTERVAL := 5

# 结束画面场景
@export var end_screen_scene: PackedScene

@onready var timer:Timer = $Timer

# 竞技场难度等级
var arena_difficulty := 0

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)

func _process(_delta: float) -> void:
	# 提前计算下次生成竞技场难度提升时间
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INTERVAL)
	# 当结束时间小于或等于下个目标时间时
	if timer.time_left <= next_time_target:
		# 竞技场难度提升一集
		arena_difficulty += 1
		# 并且触发竞技场难度升级信号
		arena_difficulty_increased.emit(arena_difficulty)
	
# 获取已经过去的时间
func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left

# 当时间结束时
func on_timer_timeout():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	# 设置获胜画面
	end_screen_instance.set_won_screen()
