extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

# 玩家当前已有的能力集
var current_upgrades = {}

func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)

# 升级能力
func on_level_up(current_level: int):
	# 选中的能力
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
	
	# 能力选择页面场景实例
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	# 给添加至主场景main中
	add_child(upgrade_screen_instance)
	# 连续渲染各各能力卡片至能力选择页面上
	upgrade_screen_instance.set_ability_upgrades([chosen_upgrade] as Array[AbilityUpgrade])
	

func apply_upgrade(upgrade: AbilityUpgrade):
	# 如果当前选中的能力不在能力集中
	if !current_upgrades.has(upgrade.id):
		# 则添加进能
		current_upgrades[upgrade.id] = {
			# 技能实例
			"resource": upgrade,
			# 技能等级
			"quantity": 1,
		}
	else:
		# 如果存在则将技能等级加一级
		current_upgrades[upgrade.id]["quantity"] += 1
	print(current_upgrades)
