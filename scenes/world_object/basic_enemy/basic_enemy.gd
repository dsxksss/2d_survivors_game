extends CharacterBody2D

# 最大移动速度
const MAX_SPEED = 40

func _process(_delta: float) -> void:
	var direction = get_player_position()
	velocity = direction * MAX_SPEED
	move_and_slide()

func get_player_position():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		# 返回当前敌人与玩家的坐标距离
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
