extends Node

const ReleaseLoggingEnabled = false # If true, log even on release builds.
const UseAzureServerAlways = true # If true, always defaults to the azure server.
var MuteEmotes = false
const ClientVersionString : String = "240314.0947" # YYMMDD.HHMM

const CharacterBanlist = ['carmine']

# Persistent Settings
var BGMEnabled = true
var DefaultPlayerName = ""
var GameSoundsEnabled = true
var CarmineUnlocked = false

const user_settings_file = "user://settings.json"

func get_client_version() -> String:
	var prepend = ""
	if OS.is_debug_build():
		prepend = "dev_"
	return prepend + ClientVersionString

func is_logging_enabled() -> bool:
	if ReleaseLoggingEnabled:
		return true
	return OS.is_debug_build()

func get_server_url() -> String:
	const azure_url = "wss://fightingcardslinux.azurewebsites.net"
	const local_url = "ws://localhost:8080"
	if UseAzureServerAlways or not OS.is_debug_build():
		return azure_url
	else:
		return local_url

func load_persistent_settings():
	if not FileAccess.file_exists(user_settings_file):
		print("Unable to load settings file.")
		return # Error! We don't have a save to load.

	var file = FileAccess.open(user_settings_file, FileAccess.READ)
	var text = file.get_as_text()
	var json = JSON.parse_string(text)
	print("Settings json: %s" % text)
	if 'BGMEnabled' in json and json['BGMEnabled'] is bool:
		BGMEnabled = json['BGMEnabled']
	if 'DefaultPlayerName' in json and json['DefaultPlayerName'] is String:
		DefaultPlayerName = json['DefaultPlayerName']
	if 'GameSoundsEnabled' in json and json['GameSoundsEnabled'] is bool:
		GameSoundsEnabled = json['GameSoundsEnabled']
	if 'CarmineUnlocked' in json and json['CarmineUnlocked'] is bool:
		CarmineUnlocked = json['CarmineUnlocked']


func save_persistent_settings():
	var settings = {
		"BGMEnabled": BGMEnabled,
		"DefaultPlayerName": DefaultPlayerName,
		"GameSoundsEnabled": GameSoundsEnabled,
		"CarmineUnlocked": CarmineUnlocked
	}

	var file = FileAccess.open(user_settings_file, FileAccess.WRITE)
	file.store_line(JSON.stringify(settings))

func set_bgm(value : bool):
	BGMEnabled = value
	save_persistent_settings()

func set_game_sounds_enabled(value : bool):
	GameSoundsEnabled = value
	save_persistent_settings()

func set_player_name(value : String):
	DefaultPlayerName = value
	save_persistent_settings()

func set_carmine_unlocked(value : bool):
	CarmineUnlocked = value
	save_persistent_settings()
