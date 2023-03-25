extends Node

class_name ExperienceManager

signal experience_update(current_experience: float,target_experience: float)

# 每级经验所需增长值
const TARGET_EXPERIENCE_GROWTH = 5

# 当前经验
var current_experience = 0
# 当前等级
var current_level = 1
# 目标经验
var target_experience = 5

func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)

# 递增获取的经验
func increment_experience(number: float):
	# 判断是否达到了升级要求
	current_experience = min(current_experience + number, target_experience)
	# 触发经验更新信号
	experience_update.emit(current_experience,target_experience)
	if current_experience == target_experience:
		# 升级
		current_level += 1
		# 升级目标提高
		target_experience += TARGET_EXPERIENCE_GROWTH
		# 别忘记了重置当前经验
		current_experience = 0
		experience_update.emit(current_experience,target_experience)

func on_experience_vial_collected(number: float):
	increment_experience(number)
