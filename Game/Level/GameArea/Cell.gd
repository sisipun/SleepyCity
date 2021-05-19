extends Area2D
class_name Cell


enum Effect { TARGET, TIP }
signal clicked(cell)


var _alive: bool = false
var _effects: Array = [] 
var _coord_x: int = 0
var _coord_y: int = 0


func _ready() -> void:
	$Sprite.play()
	$EffectSprite.play()


func _on_effect_animation_finished() -> void:
	if $EffectSprite.animation == "tip":
		_effects.erase(Effect.TIP)
	$EffectSprite.animation = "target" if Effect.TARGET in _effects else "default"


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
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
	$EffectSprite.scale = Vector2(size.x / sprite_size.x, size.y / sprite_size.y)
	return self


func play_target_effect() -> bool:
	if Effect.TARGET in _effects:
		return false
		
	_effects.push_back(Effect.TARGET)
	$EffectSprite.animation = "target"
	return true


func play_tip_effect() -> bool:
	if Effect.TIP in _effects:
		return false
		
	_effects.push_back(Effect.TIP)
	$EffectSprite.animation = "tip"
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
