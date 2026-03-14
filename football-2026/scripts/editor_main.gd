extends Control


# ============================================================
# SEGNALI
# ============================================================
signal navigation_back_requested

func _ready() -> void:
	$VBoxContainer/Players.grab_click_focus()

# ============================================================
# HOVER DEI BOTTONI
# ============================================================

func _on_players_mouse_entered() -> void:
	$VBoxContainer/Players.grab_focus()

func _on_teams_mouse_entered() -> void:
	$VBoxContainer/Teams.grab_focus()

func _on_transfers_mouse_entered() -> void:
	$VBoxContainer/Transfers.grab_focus()

func _on_nationals_mouse_entered() -> void:
	$VBoxContainer/Nationals.grab_focus()

func _on_cups_mouse_entered() -> void:
	$VBoxContainer/Cups.grab_focus()

func _on_leagues_mouse_entered() -> void:
	$VBoxContainer/Leagues.grab_focus()

func _on_career_mouse_entered() -> void:
	$VBoxContainer/Career.grab_focus()

func _on_back_mouse_entered() -> void:
	$VBoxContainer/Back.grab_focus()

# ============================================================
# FUNZIONALITA DEI BOTTONI
# ============================================================

func _on_back_pressed() -> void:
	navigation_back_requested.emit()
