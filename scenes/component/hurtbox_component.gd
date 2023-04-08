extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent

func _ready() -> void:
	area_entered.connect(on_area_antered)
	
func on_area_antered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	hit.emit()
