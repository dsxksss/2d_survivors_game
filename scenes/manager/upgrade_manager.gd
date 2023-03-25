extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager

# 当前已有能力集
var current_upgrades = {}

func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)

# 升级能力
func on_level_up(current_level: int):
	# 选中的能力
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
	
	# 如果当前选中的能力不在能力集中
	if !current_upgrades.has(chosen_upgrade.id):
		# 则添加进能
		current_upgrades[chosen_upgrade.id] = {
			# 技能实例
			"resource": chosen_upgrade,
			# 技能等级
			"quantity": 1,
		}
	else:
		# 如果存在则将技能等级加一级
		current_upgrades[chosen_upgrade.id]["quantity"] += 1
	print(current_upgrades)
