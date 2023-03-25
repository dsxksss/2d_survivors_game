extends Node

class_name HealthComponent

# 死亡信号
signal died

# 最大血量
@export var max_health: float = 10

var current_health

func _ready() -> void:
	current_health = max_health

# 使角色受伤函数
func damage(damage_amount: float):
	# max函数只取两边的最大值
	current_health = max(current_health - damage_amount, 0)
	# 在下一个空闲帧中再调用检查是否受伤死亡函数
	Callable(check_death).call_deferred()

func check_death():
	if current_health == 0:
		# 当受伤达到一定量级则通知触发died相关的信号
		died.emit()
		# 并且释放掉实例化了本组件的根场景
		owner.queue_free()
