extends Node

@export var axe_ability: PackedScene
@onready var timer:Timer = $Timer

const BASE_DAMAGE = 15

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var axe_instance = axe_ability.instantiate() as AxeAbility
	# 将剑场景放置到foreground层
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(axe_instance)
	# 赋予基本伤害
	axe_instance.hitbox_component.damage = BASE_DAMAGE
	axe_instance.global_position = player.global_position
