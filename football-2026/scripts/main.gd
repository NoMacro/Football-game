extends Control

# ============================================================
# Cosa fa
# - Gestisce il modulo attivo dentro CurrentModule.
# - All'avvio istanzia PressStartScreen.
# - Quando PressStartScreen emette il segnale start_pressed,
#   rimuove la schermata attuale e carica MainMenuScreen.
#
# Parametri
# - Nessuno.
#
# Restituisce
# - Nessun valore. Gestisce solo il flusso delle schermate.
#
# Note
# - Si aspetta che esista un figlio chiamato "CurrentModule".
# - Si aspetta che PressStartScreen abbia il segnale "start_pressed".
# ============================================================

const PRESS_START_SCENE: PackedScene = preload("res://scenes/screens/press_start_screen.tscn")
const MAIN_MENU_SCENE: PackedScene = preload("res://scenes/screens/main_menu_screen.tscn")

@onready var current_module: Control = $CurrentModule

var current_screen: Control = null


func _ready() -> void:
	show_press_start_screen()


func show_press_start_screen() -> void:
	var new_screen: Control = PRESS_START_SCENE.instantiate() as Control
	
	clear_current_screen()
	current_module.add_child(new_screen)
	current_screen = new_screen
	
	if current_screen.has_signal("start_pressed"):
		current_screen.start_pressed.connect(_on_press_start_screen_start_pressed)


func show_main_menu_screen() -> void:
	var new_screen: Control = MAIN_MENU_SCENE.instantiate() as Control
	
	clear_current_screen()
	current_module.add_child(new_screen)
	current_screen = new_screen


func clear_current_screen() -> void:
	if current_screen != null:
		current_screen.queue_free()
		current_screen = null


func _on_press_start_screen_start_pressed() -> void:
	show_main_menu_screen()
