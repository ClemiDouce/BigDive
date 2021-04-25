extends Node

onready var sound_players = $SoundsPlayer
onready var music_player = $MusicPlayer
onready var tween = $Tween

# Music
const music_game_intro = preload("res://assets/music/mu_gmp2_intro.ogg")
const music_game_loop = preload("res://assets/music/mu_gmp2_loop.ogg")
const music_menu = preload("res://assets/music/mu_menu1.ogg")

const MUSIC_BUS_INDEX = 1
const SOUND_BUS_INDEX = 2

var music_level : float = 100.0 setget set_music_level
var sound_level : float = 100.0 setget set_sound_level
var paused = false
var pause_break = false

var old_volume = 0

func get_music(music: String) -> AudioStreamOGGVorbis:
	match(music):
		'menu':
			return music_menu
		'intro':
			return music_game_intro
		'loop':
			return music_game_loop
		_:
			return music_menu
	
func play_music(music_name: String):
	music_player.stream = get_music(music_name)
	music_player.play()

func change_music(music_name: String, speed: float = 1.0):
	tween.interpolate_property(music_player, 'volume_db', music_player.volume_db, -60, speed, Tween.TRANS_LINEAR,
		Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	music_player.stop()
	music_player.stream = get_music(music_name)
	music_player.play()
	tween.interpolate_property(music_player, 'volume_db', music_player.volume_db, 0, speed, Tween.TRANS_LINEAR,
		Tween.EASE_IN)
	tween.start()

func stop_music(speed:float = 1):
	tween.interpolate_property(music_player, 'volume_db', music_player.volume_db, -60, speed, Tween.TRANS_LINEAR,
		Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	music_player.stop()
	music_player.volume_db = 0

func mute_music():
	old_volume = music_level
	self.music_level = 0

func demute_music():
	self.music_level = old_volume

func music_out():
	tween.interpolate_property(music_player, 'volume_db', 0, -60, 3, Tween.TRANS_LINEAR,
		Tween.EASE_IN)
	tween.start()

func music_in():
	tween.interpolate_property(music_player, 'volume_db', -60, 0, 3, Tween.TRANS_LINEAR,
		Tween.EASE_IN)
	tween.start()

func set_music_level(new_level: float):
	music_level = new_level
	var mapped_level = Utils.remap_range(music_level, 0,100, -60, 0)
	AudioServer.set_bus_volume_db(MUSIC_BUS_INDEX, mapped_level)

func set_sound_level(new_level: float):
	sound_level = new_level
	var mapped_level = Utils.remap_range(sound_level, 0,100, -60, -6)
	AudioServer.set_bus_volume_db(SOUND_BUS_INDEX, mapped_level)

func play_sound(sound:AudioStreamSample):
	for player in sound_players.get_children():
		if not player.playing:
			player.stream = sound
			player.play()
			return

func _on_MusicPlayer_finished():
	if music_player.stream == music_menu:
		return
	elif music_player.stream == music_game_intro:
		music_player.stream = music_game_loop
		music_player.play()
	else:
		return
