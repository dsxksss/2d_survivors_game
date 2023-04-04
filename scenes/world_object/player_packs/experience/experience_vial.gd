extends Node2D

# 拾取经验瓶所增加的基础经验
const BASE_EXPERIENCE_NUMBER = 1

func _ready() -> void:
	$Area2D.area_entered.connect(on_area_entered)

func on_area_entered(other_area: Area2D):
	GameEvents.emit_experience_vial_collected(BASE_EXPERIENCE_NUMBER)
	# 拾取后释放经验瓶
	queue_free()
