extends Area2D

enum Effect { TARGET, TIP }

signal clicked(cell)

var alive = false
var effects = [] 
var coord_x = 0
var coord_y = 0
var neighbors_count = 0

func _ready():
	$Sprite.play()
	$EffectSprite.play()

func _on_effect_animation_finished():
	if $EffectSprite.animation == "tip":
		effects.erase(Effect.TIP)
	$EffectSprite.animation = "target" if Effect.TARGET in effects else "default"

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("clicked", self)

func init(coord_x, coord_y, position, size, alive = false):
	var sprite_size = $Sprite.frames.get_frame($Sprite.animation, 0).get_size()
	self.coord_x = coord_x
	self.coord_y = coord_y
	self.position = position
	set_alive(alive)
	$Collision.shape.extents = Vector2(size.x / 2, size.y / 2)
	$Sprite.scale = Vector2(size.x / sprite_size.x, size.y / sprite_size.y)
	$Sprite.frame = $Sprite.frames.get_frame_count($Sprite.animation) - 1
	$EffectSprite.scale = Vector2(size.x / sprite_size.x, size.y / sprite_size.y)
	return self

func play_target_effect():
	if Effect.TARGET in effects:
		return false
		
	effects.push_back(Effect.TARGET)
	$EffectSprite.animation = "target"
	return true
	
func play_tip_effect():
	if Effect.TIP in effects:
		return false

	effects.push_back(Effect.TIP)
	$EffectSprite.animation = "tip"
	return true

func is_alive():
	return alive

func set_alive(alive):
	self.alive = alive
	if self.alive:
		$Sprite.animation = "alive"
	else:
		$Sprite.animation = "dead"
