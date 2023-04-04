extends Node

# 物品掉落几率
@export_range(0,1) var drop_percent: float = 0.5
# 掉落的物品场景
@export var vial_scene:PackedScene
# 对象健康状态组件索引
@export var health_component:Node

func _ready() -> void:
	# 如果该对象发出了died信号，则执行on_died函数
	(health_component as HealthComponent).died.connect(on_died)
	
# 当对象死亡时做的事情
func on_died():
	# 当随机数大于掉落几率时，则不掉落物品
	if randf() > drop_percent:
		return
		
	# 当物品场景为null时，则不掉落物品
	if vial_scene == null:
		return
	
	# 当“自身”不为Node2D对象时，则也不掉落物品
	if not owner is Node2D:
		return
	
	# 掉落位置
	var spawn_position = (owner as Node2D).global_position
	# 掉落物品的场景实例
	var vial_instance = vial_scene.instantiate() as Node2D
	# 给当前对象添加掉落物品
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(vial_instance)
	# 将掉落物品位置设置到对象所在的位置上
	vial_instance.global_position = spawn_position
