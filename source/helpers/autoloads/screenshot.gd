extends Node

# Private constants

const __OUTPUT_DIRECTORY: String = "screenshots"
const __OUTPUT_FILE_NAME: String = "%04d-%02d-%02d_%02d.%02d.%02d.png"


# Private variables

var __activate_prev: bool = false
var __activate_curr: bool = true


# Lifecycle methods

func _ready() -> void:
	IOHelper.directory_create(__OUTPUT_DIRECTORY)

	self.pause_mode = Node.PAUSE_MODE_PROCESS


func _process(_delta: float) -> void:
	# TODO: Update to input action

	__activate_prev = __activate_curr
	__activate_curr = Input.is_key_pressed(KEY_S)

	var pressed = !__activate_prev && __activate_curr

	if Input.is_key_pressed(KEY_CONTROL) && Input.is_key_pressed(KEY_SHIFT) && pressed:
		self.__screenshot()


# Private methods

func __screenshot():
	var capture: Image = self.get_viewport().get_texture().get_data()

	capture.flip_y()

	var datetime: Dictionary = OS.get_datetime(true)
	var file_name: String = __OUTPUT_FILE_NAME % [
		datetime["year"],
		datetime["month"],
		datetime["day"],
		datetime["hour"],
		datetime["minute"],
		datetime["second"],
	]

	var capture_result: int = capture.save_png("user://%s/%s" % [__OUTPUT_DIRECTORY, file_name])
	if capture_result != OK:
		pass # TODO: Call logger
