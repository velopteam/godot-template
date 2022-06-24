extends Node 


# Public signals

signal setting_changed(name, value)


# Private consts

const __SETTINGS_PATH = "settings.json"


# Private variables 

var __settings: Dictionary = {}
var __settings_default: Dictionary = {
	"volume": {
		"master": 1.0,
		"music": 1.0,
		"sound_effects": 1.0,
	},
	"input": {},
	"graphics": {
		"fullscreen": false,
	},
	"gameplay": {
		"shake_intensity": 1.0,
	},
}


# Lifecycle methods

func _ready() -> void: 
	settings_load()


# Public methods 

func get(name, default = null): # Variant
	pass


func set(name: String, value, save: bool = false) -> void: 
	pass


func settings_load() -> void: 
	if IOHelper.file_exists(__SETTINGS_PATH):
		var setting_string: String = IOHelper.file_load(__SETTINGS_PATH)
		
		__settings = parse_json(setting_string)
		
		if __merge_settings(__settings, __settings_default): 
			settings_save()
		
		# TODO: Logger
	else:
		__settings = __settings_default
		
		settings_save()
		
		# TODO: Logger


func settings_save() -> void: 
	var setting_string: String = to_json(__settings)
		
	IOHelper.file_save(__SETTINGS_PATH, setting_string)


# Private methods 

func __merge_settings(a: Dictionary, b: Dictionary) -> bool: 
	var changed: bool = false
	
	for key in b: 
		if !a.has(key) || typeof(a[key]) != typeof(b[key]):
			a[key] = b[key]
			
			changed = true
		elif b[key] is Dictionary:
			changed = changed || __merge_settings(a[key], b[key]) 
			
	return changed
