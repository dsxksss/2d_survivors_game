extends CharacterBody2D

const MAX_SPEED = 200

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity = direction * MAX_SPEED
	move_and_slide()
	
# 获取玩家移动偏移量
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)
