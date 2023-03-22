extends CharacterBody2D

# 移动速度
const MAX_SPEED = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 单物体被接触时触发
	$Area2D.area_entered.connect(on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = get_player_position()
	velocity = direction * MAX_SPEED
	move_and_slide()

func get_player_position():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		# 返回当前敌人与玩家的坐标距离
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO

func on_area_entered(other_area:Area2D):
	# 当碰撞之后释放自身
	queue_free()
