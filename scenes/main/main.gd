extends Node

# 结束画面场景
@export var end_screen_scene: PackedScene

func _ready() -> void:
	# 当玩家死亡时触发on_plyer_died
	$%Player.health_component.died.connect(on_plyer_died)

func on_plyer_died():
	# 存储结束画面场景实例
	var end_screen_instance = end_screen_scene.instantiate()
	# 导入结束窗口至主场景后
	add_child(end_screen_instance)
	# 调用该场景中定义的失败画面
	end_screen_instance.set_lost_screen()
