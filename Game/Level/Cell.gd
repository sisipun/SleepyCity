extends Area2D
class_name Cell


signal clicked(cell)


var _alive: bool = false
var _coord_x: int = 0
var _coord_y: int = 0


func _ready() -> void:
	$Sprite.play()
	$Border.play()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		stop_tip_effect()
		emit_signal("clicked", self)


func init(
		coord_x: int, 
		coord_y: int, 
		position: Vector2, 
		size: Vector2, 
		alive: bool = false
	) -> Cell:
	var sprite_size: Vector2 = $Sprite.frames.get_frame($Sprite.animation, 0).get_size()
	self.position = position
	_coord_x = coord_x
	_coord_y = coord_y
	set_alive(alive)
	$Collision.shape.extents = Vector2(size.x / 2, size.y / 2)
	$Sprite.scale = Vector2(size.x / sprite_size.x, size.y / sprite_size.y)
	$Sprite.frame = $Sprite.frames.get_frame_count($Sprite.animation) - 1
	$Border.scale = Vector2(size.x / sprite_size.x, size.y / sprite_size.y)
	$Target.scale = Vector2(size.x / sprite_size.x, size.y / sprite_size.y)
	$Tip.scale = Vector2(size.x / sprite_size.x, size.y / sprite_size.y)
	return self


func play_target_effect() -> bool:
	if $Target.is_playing():
		return false
	
	$Target.play()
	$Target.show()
	return true


func stop_target_effect() -> bool:
	if not $Target.is_playing():
		return false
	
	$Target.stop()
	$Target.hide()
	return true


func play_tip_effect() -> bool:
	if $Tip.is_playing():
		return false
		
	$Tip.play()
	$Tip.show()
	return true


func stop_tip_effect() -> bool:
	if not $Tip.is_playing():
		return false
		
	$Tip.stop()
	$Tip.hide()
	return true


func get_coordinates() -> Vector2:
	return Vector2(_coord_x, _coord_y)


func is_alive() -> bool:
	return _alive


func set_alive(alive: bool) -> void:
	_alive = alive
	if _alive:
		$Sprite.animation = "alive"
	else:
		$Sprite.animation = "dead"
