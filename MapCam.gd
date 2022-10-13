extends Camera2D


# Declare member variables here. Examples:
var move_speed = 0.1
var move_factor = 0.25

var drag_factor = 2.75
var do_drag = false

var min_zoom = 0.75
var max_zoom = 1.95
var zoom_factor = 0.1
var zoom_duration = 0.2

var _zoom_level = 1.0 setget _set_zoom_level

var tween: Tween

var test_print = false 

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = $Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_zoom_level(value: float, duration=zoom_duration, follow_mouse=true):
	if value >= min_zoom and value <= max_zoom:
		_zoom_level = clamp(value, min_zoom, max_zoom)
		tween.interpolate_property(
			self,
			"zoom",
			zoom,
			Vector2(_zoom_level, _zoom_level),
			duration,
			tween.TRANS_SINE,
			tween.EASE_OUT
		)
		if follow_mouse:
			var mouse_position = get_viewport().get_mouse_position()
			var position_offset = mouse_position - self.position
			var new_position = self.position + position_offset * move_factor
			tween.interpolate_property(
				self, 
				"position", 
				self.position, 
				new_position, 
				move_speed, 
				Tween.TRANS_LINEAR, 
				Tween.EASE_IN_OUT
			)
		tween.start()
		
func _drag_camera(direction_vector):
	var new_position = self.position - direction_vector * drag_factor
	tween.interpolate_property(
		self, 
		"position", 
		self.position, 
		new_position, 
		move_speed, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	tween.start()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			if event.is_pressed():
				_set_zoom_level(_zoom_level - zoom_factor)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			if event.is_pressed():
				_set_zoom_level(_zoom_level + zoom_factor)
		elif event.button_index == BUTTON_RIGHT:
			do_drag = event.is_pressed()
	elif event is InputEventMouseMotion:
		if do_drag:
			_drag_camera(event.relative)
