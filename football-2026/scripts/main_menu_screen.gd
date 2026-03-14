extends Control


# ============================================================
# HOVER DEI BOTTONI
# ============================================================
signal navigation_push_requested(target_screen_id: int, target_screen_data: Variant)


func _ready() -> void:
	$ButtonsContainer/Friendly.grab_focus()

# ============================================================
# HOVER DEI BOTTONI
# ============================================================
func _on_friendly_mouse_entered() -> void:
	$ButtonsContainer/Friendly.grab_focus()

func _on_cup_mouse_entered() -> void:
	$ButtonsContainer/Cup.grab_focus()

func _on_league_mouse_entered() -> void:
	$ButtonsContainer/League.grab_focus()

func _on_player_career_mouse_entered() -> void:
	$ButtonsContainer/PlayerCareer.grab_focus()

func _on_manager_career_mouse_entered() -> void:
	$ButtonsContainer/ManagerCareer.grab_focus()

func _on_options_mouse_entered() -> void:
	$ButtonsContainer/Options.grab_focus()

func _on_editor_mouse_entered() -> void:
	$ButtonsContainer/Editor.grab_focus()

func _on_exit_mouse_entered() -> void:
	$ButtonsContainer/Exit.grab_focus()

# ============================================================
# FUNZIONALITA DEI BOTTONI
# ============================================================
func _on_editor_pressed() -> void:
	navigation_push_requested.emit(2, null)

func _on_exit_pressed() -> void:
	get_tree().quit()
