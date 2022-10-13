extends TileMap

# Current turn, incremented each time player or enemy finishes a turn
var turn_count = 0
# Current phase, 0=player 1=enemy
var phase = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func path_find(unit):
	var move_distance = unit.move
	var start_tile = $Grid.world_to_map(unit.position)
	var x = int(start_tile.x/$Grid.scale.x)
	var y = int(start_tile.y/$Grid.scale.y)
	$"Select Cell".current_unit = unit
	self.set_path_tile(x, y, move_distance)
	
func set_path_tile(x, y, distance):
	# Check if at max distance
	if distance < 0:
		return
		
	# Check if valid play area on grid
	var grid_cell = $Grid.get_cell(x, y)
	if grid_cell == -1:
		return
		
	# If unit does not fly, check mobility map
	var mobility_cell = $"Mobility Map".get_cell(x, y)
	if mobility_cell == -1:
		return
		
	# Check if space is not taken by another unit
	# # If taken by an enemy, continue to path find
	# # If taken by an ally, do not set as valid path but continue to path find
	
	$"Select Cell".mark_cell(x, y)
	self.set_path_tile(x+1, y, distance-1)
	self.set_path_tile(x-1, y, distance-1)
	self.set_path_tile(x, y+1, distance-1)
	self.set_path_tile(x, y-1, distance-1)
	
func stop_path_find():
	$"Select Cell".clear()
	$"Select Cell".current_unit = null
