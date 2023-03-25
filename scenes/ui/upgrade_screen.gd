extends CanvasLayer

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
