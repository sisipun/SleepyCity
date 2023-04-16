extends Node


var game: GameInfo = GameInfo.new({
	1: LevelInfo.new(
		3,
		5,
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
		3,
		true
	),
	2: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,2)
		],
		[
			Vector2(0,1), 
			Vector2(0,2), 
			Vector2(0,3),
			Vector2(1,2),
			Vector2(2,2)
		],
		3
	),
	3: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(1,0)
		],
		[
			Vector2(0,0), 
			Vector2(1,0), 
			Vector2(1,1),
			Vector2(1,4),
			Vector2(2,0)
		],
		3
	),
	4: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,0)
		],
		[
			Vector2(0,0), 
			Vector2(0,1), 
			Vector2(0,4),
			Vector2(1,0),
			Vector2(2,0)
		],
		3
	),
	5: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(2,4)
		],
		[
			Vector2(0,4), 
			Vector2(1,4), 
			Vector2(2,0),
			Vector2(2,3),
			Vector2(2,4)
		],
		3
	),
	6: LevelInfo.new(
		3,
		5,
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
		4
	),
	7: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(1,2),
			Vector2(1,3)
		],
		[
			Vector2(0,2), 
			Vector2(0,3),
			Vector2(1,1),
			Vector2(1,4),
			Vector2(2,2),
			Vector2(2,3),
		],
		4
	),
	8: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,1),
			Vector2(0,2),
		],
		[
			Vector2(0,0), 
			Vector2(0,3),
			Vector2(1,1),
			Vector2(1,2),
			Vector2(2,1),
			Vector2(2,2),
		],
		5
	),
	9: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(1,0),
			Vector2(1,4)
		],
		[
			Vector2(0,0), 
			Vector2(0,4),
			Vector2(1,1),
			Vector2(1,3),
			Vector2(2,0),
			Vector2(2,4),
		],
		4
	),
	10: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,2),
			Vector2(2,2),
		],
		[
			Vector2(0,1), 
			Vector2(0,3),
			Vector2(2,1),
			Vector2(2,3),
		],
		5
	),
	11: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,2),
			Vector2(1,2),
		],
		[
			Vector2(0,1), 
			Vector2(0,3),
			Vector2(1,1),
			Vector2(1,3),
		],
		5
	),
	12: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,3),
			Vector2(2,1),
		],
		[
			Vector2(0,1), 
			Vector2(0,2),
			Vector2(0,3),
			Vector2(0,4),
			Vector2(1,1),
			Vector2(1,3),
			Vector2(2,0),
			Vector2(2,1),
			Vector2(2,2),
			Vector2(2,3),
		],
		5
	),
	13: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,0),
			Vector2(2,4),
		],
		[
			Vector2(0,0), 
			Vector2(0,1),
			Vector2(1,0),
			Vector2(1,4),
			Vector2(2,3),
			Vector2(2,4),
		],
		5
	),
	14: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,0),
			Vector2(2,0),
		],
		[
			Vector2(0,1), 
			Vector2(0,4),
			Vector2(2,1),
			Vector2(2,4),
		],
		5
	),
	15: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,1),
			Vector2(2,2),
		],
		[
			Vector2(0,0), 
			Vector2(0,1),
			Vector2(1,1),
			Vector2(1,2),
			Vector2(2,2),
			Vector2(2,3),
		],
		5
	),
	16: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(1,1),
			Vector2(1,2),
			Vector2(1,3)
		],
		[
			Vector2(0,1), 
			Vector2(0,2), 
			Vector2(0,3),
			Vector2(1,0),
			Vector2(1,2),
			Vector2(1,4),
			Vector2(2,1),
			Vector2(2,2),
			Vector2(2,3),
		],
		6
	),
	17: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,1),
			Vector2(0,2),
			Vector2(0,3),
		],
		[
			Vector2(0,0),
			Vector2(0,2),
			Vector2(0,4),
			Vector2(1,1),
			Vector2(1,2),
			Vector2(1,3),
			Vector2(2,1),
			Vector2(2,2),
			Vector2(2,3),
		],
		6
	),
	18: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,2),
			Vector2(1,2),
			Vector2(2,2)
		],
		[
			Vector2(0,1), 
			Vector2(0,2), 
			Vector2(0,3),
			Vector2(1,1),
			Vector2(1,2),
			Vector2(1,3),
			Vector2(2,1),
			Vector2(2,2),
			Vector2(2,3),
		],
		6
	),
	19: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(0,0),
			Vector2(0,4),
			Vector2(2,0),
			Vector2(2,4),
		],
		[
			Vector2(0,0), 
			Vector2(0,1), 
			Vector2(0,3),
			Vector2(0,4),
			Vector2(2,0),
			Vector2(2,1),
			Vector2(2,3),
			Vector2(2,4),
		],
		8
	),
	20: LevelInfo.new(
		3,
		5,
		[
		], 
		[
			Vector2(1,0),
			Vector2(1,1),
			Vector2(1,2),
			Vector2(1,3),
			Vector2(1,4),
		],
		[
			Vector2(0,0),
			Vector2(0,1),
			Vector2(0,2),
			Vector2(0,3),
			Vector2(0,4),
			Vector2(1,0),
			Vector2(1,1),
			Vector2(1,2),
			Vector2(1,3),
			Vector2(1,4),
			Vector2(2,0),
			Vector2(2,1),
			Vector2(2,2),
			Vector2(2,3),
			Vector2(2,4),
		],
		10
	),
})
var _save_path: String = "user://saves/"
var _save_file: String = "levels.json"
var _current_version: String = "1.0.1"


func _ready() -> void:
	EventStorage.game_updated.connect(_on_game_updated)
	
	if not FileAccess.file_exists(_save_path + _save_file):
		EventStorage.emit_signal("game_updated", game)
		return
	
	var file: FileAccess = FileAccess.open(_save_path + _save_file, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	var version: String = data["version"]
	if version == _current_version:
		game = GameInfoParser.read(data)


func _on_game_updated(_game: GameInfo) -> void:
	if not DirAccess.dir_exists_absolute(_save_path):
		DirAccess.make_dir_absolute(_save_path)
		
	var data: Dictionary = GameInfoParser.write(self.game)
	data["version"] = _current_version
	
	var file: FileAccess = FileAccess.open(_save_path + _save_file, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
	file.close()
	EventStorage.emit_signal("game_saved", self.game)
