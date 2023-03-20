extends Camera2D

var target_position = Vector2.ZERO

func _ready() -> void:
	# 成为当前的活动相机
	make_current()

func _process(delta: float) -> void:
	acquire_target()
	# 平滑移动视角
	global_position = global_position.lerp(target_position,1.0 - exp(-delta * 10))
	
# 视角移动
func acquire_target():
	# 通过“组”来获取角色对象的控制节点
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0] as Node2D
		target_position =player.global_position
