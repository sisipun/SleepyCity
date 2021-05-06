extends Area2D

class_name Cell

enum Effect { TARGET, TIP, MISSING }

signal clicked(cell)
signal animation_finished(effect, cell)

const sprite_size = 128

var alive = false
var effects = [] 
var coord_x = 0
var coord_y = 0
var neighbors_count = 0

func _ready():
	$Sprite.play()
	$EffectSprite.play()

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("clicked", self)

func _on_effect_animation_finished():
	if $EffectSprite.animation == "tip":
		effects.erase(Effect.TIP)
		emit_signal("animation_finished", Effect.TIP, self)
	elif $EffectSprite.animation == "missing":
		effects.erase(Effect.MISSING)
		emit_signal("animation_finished", Effect.MISSING, self)
	$EffectSprite.animation = "target" if Effect.TARGET in effects else "default"

func init(coord_x, coord_y, position, size, alive = false):
	self.coord_x = coord_x
	self.coord_y = coord_y
	self.position = position
	set_alive(alive)
	set_neighbors_count(0)	
	$Collision.shape.extents = Vector2(size.x / 2, size.y / 2)
	$Sprite.scale = Vector2(size.x / sprite_size, size.y / sprite_size)
	$Sprite.frame = $Sprite.frames.get_frame_count($Sprite.animation) - 1
	$EffectSprite.scale = Vector2(size.x / sprite_size, size.y / sprite_size)
	$InitialSprite.scale = Vector2(size.x / sprite_size, size.y / sprite_size)
	if (alive):
		$InitialSprite.show()
	else:
		$InitialSprite.hide()
	$NeighborsCountLabel.set_position(Vector2(-size.x / 2, -size.y / 2))
	$NeighborsCountLabel.set_size(Vector2(size.x, size.y))
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
	
func play_missing_effect():
	if Effect.MISSING in effects:
		return false

	effects.push_back(Effect.MISSING)
	$EffectSprite.animation = "missing"
	$EffectSprite.show()
	return true

func is_alive():
	return alive

func set_alive(alive):
	self.alive = alive
	if self.alive:
		$NeighborsCountLabel.add_color_override("font_color", Color("#ffffff"))
		$Sprite.animation = "alive"
	else:
		$NeighborsCountLabel.add_color_override("font_color", Color("#000000"))
		$Sprite.animation = "dead"

func set_neighbors_count(neighbors_count):
	self.neighbors_count = neighbors_count
	$NeighborsCountLabel.text = "%d" % neighbors_count
	$NeighborsCountLabel.add_color_override("font_color", Color("#ffffff") if alive else Color("#000000"))
	if neighbors_count == 0:
		$NeighborsCountLabel.hide()
	else:
		$NeighborsCountLabel.show()
