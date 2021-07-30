extends Node


var game: GameInfo = GameInfo.new({
	1: LevelInfo.new(
		3,
		6,
		LevelInfo.LevelType.DARK,
		[
		], 
		[
			Vector2(1,2)
		],
		[
			Vector2(0,2), 
			Vector2(1,1), 
			Vector2(1,2),
			Vector2(1,3),
			Vector2(2,2)
		],
		true
	),
	2: LevelInfo.new(
		3,
		6,
		LevelInfo.LevelType.DARK,
		[
		], 
		[
			Vector2(1,1),
			Vector2(1,3)
		],
		[
			Vector2(0,1), 
			Vector2(0,3),
			Vector2(1,0),
			Vector2(1,1),
			Vector2(1,3),
			Vector2(1,4),
			Vector2(2,1),
			Vector2(2,3),
		],
		true
	),
	4: LevelInfo.new(
		3,
		6,
		LevelInfo.LevelType.LIGHT,
		[
		], 
		[
			Vector2(1,2)
		],
		[
			Vector2(0,2), 
			Vector2(1,1), 
			Vector2(1,2),
			Vector2(1,3),
			Vector2(2,2)
		],
		true
	),
	5: LevelInfo.new(
		3,
		6,
		LevelInfo.LevelType.LIGHT,
		[
		], 
		[
			Vector2(1,1),
			Vector2(1,3)
		],
		[
			Vector2(0,1), 
			Vector2(0,3),
			Vector2(1,0),
			Vector2(1,1),
			Vector2(1,3),
			Vector2(1,4),
			Vector2(2,1),
			Vector2(2,3),
		],
		true
	),
})
var _save_path: String = "user://saves/"
var _save_file: String = "levels.json"
var _current_version: String = "1.0"


func _ready() -> void:
	EventStorage.connect("game_updated", self, "_on_game_updated")
	
	var file: = File.new()
	if not file.file_exists(_save_path + _save_file):
		EventStorage.emit_signal("game_updated", game)
		return
	
	file.open(_save_path + _save_file, File.READ)
	var data: Dictionary = JSON.parse(file.get_as_text()).result
	file.close()
	
	var version: String = data["version"]
	if version == _current_version:
		game = GameInfoParser.read(data)
	
	EventStorage.connect("game_updated", self, "_on_game_updated")


func _on_game_updated(game: GameInfo) -> void:
	var dir: Directory = Directory.new()
	if not dir.dir_exists(_save_path):
		dir.make_dir(_save_path)
		
	var data: Dictionary = GameInfoParser.write(self.game)
	data["version"] = _current_version
	
	var file: File = File.new()
	file.open(_save_path + _save_file, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	EventStorage.emit_signal("game_saved", self.game)
