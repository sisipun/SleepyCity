extends Area2D

class_name Cell

enum Effect { TARGET, TIP }

signal clicked(cell)
signal animation_finished(cell)

const sprite_size = 128

var alive = false
var effects = [] 
var coord_x = 0
var coord_y = 0

func _ready():
	$Sprite.play()
	$EffectSprite.play()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("clicked", self)

func _on_effect_animation_finished():
	if $EffectSprite.animation == "tip":
		effects.erase(Effect.TIP)
		$EffectSprite.animation = "target" if Effect.TARGET in effects else "default"

func init(coord_x, coord_y, position, size, alive = false):
	self.coord_x = coord_x
	self.coord_y = coord_y
	self.position = position
	set_alive(alive)
	$Collision.shape.extents = Vector2(size.x / 2, size.y / 2)
	$Sprite.scale = Vector2(size.x / sprite_size, size.y / sprite_size)
	$Sprite.frame = $Sprite.frames.get_frame_count($Sprite.animation) - 1
	$EffectSprite.scale = Vector2(size.x / sprite_size, size.y / sprite_size)	
	return self

func play_target_effect():
	if Effect.TARGET in effects:
		return false
		
	effects.push_back(Effect.TARGET)
	$EffectSprite.animation = "target"
	$EffectSprite.show()
	return true
	
func play_tip_effect():
	if Effect.TIP in effects:
		return false

	effects.push_back(Effect.TIP)
	$EffectSprite.animation = "tip"
	$EffectSprite.show()
	return true

func is_alive():
	return alive

func set_alive(alive):
	self.alive = alive
	if self.alive:
		$Sprite.animation = "alive"
	else:
		$Sprite.animation = "dead"
		

func change_alive(alive):
	if self.alive == alive:
		return
	
	$AudioAlive.play()
	set_alive(alive)
