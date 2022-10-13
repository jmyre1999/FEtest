extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_unit = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func mark_cell(x, y):
	if self.current_unit:
		self.set_cell(x, y, 0)
		
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			if self.current_unit:
				var position = get_viewport().canvas_transform.affine_inverse().xform(event.position)
				var selected_tile = self.world_to_map(position)
				var x = int(selected_tile.x/self.scale.x/2)
				var y = int(selected_tile.y/self.scale.y/2)
				self.select_cell(x, y)

func select_cell(x, y):
	if current_unit and self.get_cell(x, y) != -1:
		print("Moving to: " + str(x) + ', ' + str(y))
		current_unit.move_to_cell(self, x, y)
		self.current_unit = null
		self.clear()

