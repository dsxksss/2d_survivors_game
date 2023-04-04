extends Node

# 技能升级池
@export var upgrade_pool: Array[AbilityUpgrade]
#  经验管理器
@export var experience_manager: ExperienceManager
# 技能升级选择页面场景
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
	# 检测选中了哪个能力升级
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
	

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
	# 技能升级后
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrades)

func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
