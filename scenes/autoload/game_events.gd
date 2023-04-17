extends Node

# 拾取经验值
signal experience_vial_collected(number: float)
# 技能升级
signal ability_upgrade_added(upgrade: AbilityUpgrade,current_upgrades:Dictionary)

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade,current_upgrades:Dictionary):
	ability_upgrade_added.emit(upgrade,current_upgrades)
