extends CanvasLayer

@export var experience_manager: ExperienceManager
@onready var progress_bar = $%ProgressBar

func _ready() -> void:
	# 重写默认值5为0
	progress_bar.value = 0
	# 当经验更新信号被触发时执行on_experience_update函数
	experience_manager.experience_update.connect(on_experience_update)
	
func on_experience_update(current_experience: float, target_experience: float):
	# 按照百分比显示玩家经验值至屏幕上
	var percent = current_experience / target_experience
	progress_bar.value = percent
