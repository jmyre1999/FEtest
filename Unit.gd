extends Area2D

var actionable = true
var is_active = false
var previous_position

onready var _sprite = $Sprite

onready var _action_menu = $ActionMenu
enum ActionIds {
	WAIT = 0,
	UNDO = 1,
}
var action_offset = Vector2(20, 0)

var move = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	previous_position = self.global_position
	_action_menu.add_item('Wait', ActionIds.WAIT)
	_action_menu.add_item('Undo move', ActionIds.UNDO)
	_action_menu.connect("id_pressed", self, "_on_ActionMenu_id_pressed")
	_action_menu.connect("index_pressed", self, "_on_ActionMenu_index_pressed")
	_action_menu.set_exclusive(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_Unit_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			if self.actionable:
				_toggle_active_state()
		elif event.is_pressed() and event.button_index == BUTTON_RIGHT:
			if self.is_active:
				_toggle_active_state()

func _toggle_active_state():
	if self.is_active:
		# Current state is active, make unit inactive
		_sprite.set_animation('default')
		self.is_active = false
		self.get_parent().stop_path_find()
	else:
		# Current state is inactive, make unit active
		_sprite.set_animation('selected')
		self.is_active = true
		self.get_parent().path_find(self)
		
func move_to_cell(map, x, y):
	self.previous_position = self.global_position
	self.global_position = map.map_to_world(Vector2(x*map.scale.x*2,y*map.scale.x*2)) + map.cell_size * 2
	_toggle_active_state()
	self.actionable = false
	_action_menu.popup_centered(Vector2(_action_menu.rect_size.x, _action_menu.rect_size.y))
	
func undo_move():
	self.global_position = previous_position
	self.actionable = true
	_toggle_active_state()
	
func end_action():
	self.actionable = false

func _on_ActionMenu_id_pressed(id):
	match id:
		ActionIds.WAIT:
			end_action()
		ActionIds.UNDO:
			undo_move()

func _on_ActionMenu_index_pressed(index):
	print(index)
