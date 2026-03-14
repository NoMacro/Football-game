extends Control

# ============================================================
# Cosa fa
# - Gestisce tutta la navigazione del frontend.
# - Carica la schermata iniziale.
# - Mantiene una cronologia delle schermate precedenti.
# - Fornisce tre operazioni ufficiali:
#	1) replace_screen = sostituisce senza salvare nella cronologia
#	2) push_screen = salva la schermata attuale e va avanti
#	3) pop_screen = torna alla schermata precedente
# - Collega i segnali delle schermate al router centrale.
#
# Parametri
# - Nessuno.
#
# Restituisce
# - Nessun valore.
#
# Note
# - Si aspetta un figlio chiamato "CurrentModule".
# - Le schermate possono emettere questi segnali opzionali:
#	- start_pressed
#	- navigation_push_requested(screen_id, screen_data)
#	- navigation_replace_requested(screen_id, screen_data)
#	- navigation_back_requested
# ============================================================


# ============================================================
# ENUM DELLE SCHERMATE
# - Ogni schermata ha una identità logica stabile.
# - Il resto del progetto ragiona con questi ID,
#   non con i path dei file.
# ============================================================
enum ScreenId {
	PRESS_START,
	MAIN_MENU,
	EDITOR_MAIN,
	TEAM_SELECTION,
	OPTIONS_MENU,
	MATCH_ROOT
}


# ============================================================
# CLASSE INTERNA PER LA CRONOLOGIA DI NAVIGAZIONE
# - Salva schermata e dati associati.
# - In futuro può essere estesa senza cambiare
#   l'architettura del router.
# ============================================================
class NavigationEntry:
	var screen_id: int
	var screen_data: Variant

	func _init(new_screen_id: int, new_screen_data: Variant) -> void:
		screen_id = new_screen_id
		screen_data = new_screen_data


# ============================================================
# PRELOAD DELLE SCENE
# - Per ora carichiamo solo quelle già esistenti.
# - Le altre si aggiungeranno quando le creerai.
# ============================================================
const PRESS_START_SCENE: PackedScene = preload("res://scenes/screens/press_start_screen.tscn")
const MAIN_MENU_SCENE: PackedScene = preload("res://scenes/screens/main_menu_screen.tscn")
const MAIN_EDITOR_SCENE: PackedScene = preload("res://scenes/screens/editor_main.tscn")

# ============================================================
# RIFERIMENTI AI NODI
# ============================================================
@onready var current_module: Control = $CurrentModule


# ============================================================
# STATO DEL ROUTER
# ============================================================
var current_screen: Control = null
var current_screen_id: int = ScreenId.PRESS_START
var current_screen_data: Variant = null

var previous_screens: Array[NavigationEntry] = []


func _ready() -> void:
	replace_screen(ScreenId.PRESS_START, null)


# ============================================================
# NAVIGAZIONE PRINCIPALE
# ============================================================

func replace_screen(target_screen_id: int, target_screen_data: Variant = null) -> void:
	_load_screen(target_screen_id, target_screen_data)


func push_screen(target_screen_id: int, target_screen_data: Variant = null) -> void:
	if current_screen != null:
		var new_entry: NavigationEntry = NavigationEntry.new(current_screen_id, current_screen_data)
		previous_screens.append(new_entry)
	
	_load_screen(target_screen_id, target_screen_data)


func pop_screen() -> void:
	if previous_screens.is_empty():
		return
	
	var last_index: int = previous_screens.size() - 1
	var previous_entry: NavigationEntry = previous_screens[last_index]
	
	previous_screens.remove_at(last_index)
	_load_screen(previous_entry.screen_id, previous_entry.screen_data)


# ============================================================
# CARICAMENTO INTERNO DELLA SCHERMATA
# - Questa è la vera funzione centrale del router.
# ============================================================
func _load_screen(target_screen_id: int, target_screen_data: Variant = null) -> void:
	var target_scene: PackedScene = _get_scene_for_screen(target_screen_id)
	var new_screen: Control = target_scene.instantiate() as Control
	
	_clear_current_screen()
	current_module.add_child(new_screen)
	
	current_screen = new_screen
	current_screen_id = target_screen_id
	current_screen_data = target_screen_data
	
	_configure_current_screen()


func _clear_current_screen() -> void:
	if current_screen != null:
		current_screen.queue_free()
		current_screen = null


# ============================================================
# MAPPING ID SCHERMATA -> PACKEDSCENE
# - Tutti i path vivono qui.
# - Se in futuro cambi una scena, la aggiorni qui
#   e basta.
# ============================================================
func _get_scene_for_screen(screen_id: int) -> PackedScene:
	match screen_id:
		ScreenId.PRESS_START:
			return PRESS_START_SCENE
		
		ScreenId.MAIN_MENU:
			return MAIN_MENU_SCENE
		
		ScreenId.EDITOR_MAIN:
			return MAIN_EDITOR_SCENE
		_:
			push_error("ScreenId non gestito in _get_scene_for_screen(): %s" % str(screen_id))
			return MAIN_MENU_SCENE


# ============================================================
# CONFIGURAZIONE DELLA SCHERMATA APPENA CARICATA
# - Collega i segnali opzionali, se presenti.
# - In questo modo Main resta il solo router centrale.
# ============================================================
func _configure_current_screen() -> void:
	if current_screen == null:
		return
	
	if current_screen.has_signal("start_pressed"):
		current_screen.connect("start_pressed", Callable(self, "_on_start_pressed"))
	
	if current_screen.has_signal("navigation_push_requested"):
		current_screen.connect("navigation_push_requested", Callable(self, "_on_navigation_push_requested"))
	
	if current_screen.has_signal("navigation_replace_requested"):
		current_screen.connect("navigation_replace_requested", Callable(self, "_on_navigation_replace_requested"))
	
	if current_screen.has_signal("navigation_back_requested"):
		current_screen.connect("navigation_back_requested", Callable(self, "_on_navigation_back_requested"))


# ============================================================
# CALLBACK DEI SEGNALI
# ============================================================

func _on_start_pressed() -> void:
	replace_screen(ScreenId.MAIN_MENU, null)


func _on_navigation_push_requested(target_screen_id: int, target_screen_data: Variant = null) -> void:
	push_screen(target_screen_id, target_screen_data)


func _on_navigation_replace_requested(target_screen_id: int, target_screen_data: Variant = null) -> void:
	replace_screen(target_screen_id, target_screen_data)


func _on_navigation_back_requested() -> void:
	pop_screen()
