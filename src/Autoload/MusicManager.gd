extends Node

onready var sound_player = AudioStreamPlayer.new()
onready var music_player = AudioStreamPlayer.new()
onready var interface_player = AudioStreamPlayer.new()
onready var tween = Tween.new()

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


func _ready():
	music_player.connect("finished", self, '_on_music_player_finished')
	music_player.bus = 'Music'
	sound_player.bus = 'Sound'
	interface_player.bus = 'Sound'
	add_child(music_player)
	add_child(sound_player)
	add_child(interface_player)
	add_child(tween)
	
func play_music(music : AudioStreamOGGVorbis):
	paused = false
	music_player.stream = music
	music_player.play()

func stop_music(speed:float = 1):
	paused = true
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

func _on_music_player_finished():
	if self.paused == true:
		return
#	if music_player.stream == music_intro:
#		music_player.stream = music_loop
#		music_player.play()

func play_sound(sound_to_play:String):
	sound_player.play()
	
func play_interface_sound(sound_to_play:String):
	interface_player.play()
