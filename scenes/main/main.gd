extends Node

@export var end_screen_scene: PackedScene

func _ready() -> void:
	$%Player.health_component.died.connect(on_plyer_died)

func on_plyer_died():
	var end_screen_instance = end_screen_scene.instantiate()
	add_child(end_screen_instance)
	# 导入结束窗口至主场景后
	# 调用该场景中定义的失败画面
	end_screen_instance.set_lost_screen()
