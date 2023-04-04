extends CharacterBody2D

# 最大移动速度
const MAX_SPEED = 40

# 生命组件
@onready var health_component:HealthComponent = $HealthComponent

func _ready() -> void:
	# 当物体被接触时触发
	$Area2D.area_entered.connect(on_area_entered)

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
	# 当碰撞之后受伤100点伤害
	health_component.damage(100)
