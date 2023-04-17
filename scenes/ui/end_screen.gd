extends CanvasLayer

@onready var titleLabel:Label = $%TitleLabel
@onready var descriptionLabel:Label = $%DescriptionLabel
@onready var restartButton:Button = $%RestartButton
@onready var quitButton:Button = $%QuitButton

func _ready() -> void:
	# 暂停游戏
	get_tree().paused = true
	# 当按下重新启动按钮后触发on_restart_button_pressed函数
	restartButton.pressed.connect(on_restart_button_pressed)
	# 当按下退出按钮后触发on_quit_button_pressed函数
	quitButton.pressed.connect(on_quit_button_pressed)
	
func set_lost_screen():
	titleLabel.text = "游戏结束"
	descriptionLabel.text = "玩家死亡,你输了!"

func set_won_screen():
	titleLabel.text = "游戏结束"
	descriptionLabel.text = "你赢得了游戏的胜利!!"
	
func on_restart_button_pressed():
	# 记住得先解除游戏暂停再去重载场景
	# 并且也别忘记了把该场景根节点的processMode设置为Always
	# 这样才可以保持这个场景不受暂停的影响
	get_tree().paused = false
	# 重新载入主场景
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	
func on_quit_button_pressed():
	# 关闭游戏
	get_tree().quit()
