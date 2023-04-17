extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

# 技能选择卡片页面场景
@export var upgrade_card_scenc: PackedScene
@onready var card_container: HBoxContainer = $%CardContainer

func _ready() -> void:
	# 当选择能力面板出现时 设置全局暂停
	get_tree().paused = true

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		# 实例化能力卡片
		var card_instance = upgrade_card_scenc.instantiate()
		# 添加至能力选择页面容器内
		card_container.add_child(card_instance)
		# 并且设置所需的技能名字和技能描述
		card_instance.set_ability_upgrade(upgrade)
		# 当选中事件触发时,bind函数可以给一个无参信号附加其他数据
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))

# 本项目里有很多这种写法,其实是为了单一职责，
# 每一个函数都有自己的事情,不要让多个人的工作交给一个人干
func on_upgrade_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	# 解除游戏暂停
	get_tree().paused = false
	# 释放能力选择面板
	queue_free()
