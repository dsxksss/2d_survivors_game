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
	# 检查掉落几率
	if randf() > drop_percent:
		return
		
	if vial_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	# 掉落位置
	var spawn_position = (owner as Node2D).global_position
	# 掉落物品的场景实例
	var vial_instance = vial_scene.instantiate() as Node2D
	# 给当前对象添加掉落物品
	owner.get_parent().add_child(vial_instance)
	# 将掉落物品位置设置到对象所在的位置上
	vial_instance.global_position = spawn_position
