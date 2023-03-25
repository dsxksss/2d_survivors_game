extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description: Label = $%DescriptionLabel

func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description.text = upgrade.description
