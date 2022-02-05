tool
extends Control


# Public variables

export(String) var title: String = "Title" setget __title_set
export(Color) var color_title: Color = Color.white setget __color_title_set

export(String) var subtitle: String = "Subtitle" setget __subtitle_set
export(Color) var color_subtitle: Color = Color.white setget __color_subtitle_set

export(String, FILE, "*.json") var credits_file: String = "" setget __credits_file_set
export(Color) var color_credit_role: Color = Color.white setget __color_credit_role_set
export(Color) var color_credit_name: Color = Color.white setget __color_credit_name_set

export(float, 10.0, 40.0) var speed: float = 10.0


# Private variables

var __credits_data: Array = []


# Lifecycle methods

func _set(property: String, value) -> bool:
	print(property, value)

	return true


# Private methods

func __load_credits() -> Array:
	if !IOHelper.file_exists(credits_file, false):
		# TODO: Add logger

		return []

	var credits_string: String = IOHelper.file_load(credits_file, false)

	var result: JSONParseResult = JSON.parse(credits_string)
	if result.error:
		# TODO: Add logger

		return []

	return result.result


func __color_credit_name_set(value: Color) -> void:
	color_credit_name = value

	__update_text_credits()


func __color_credit_role_set(value: Color) -> void:
	color_credit_role = value

	__update_text_credits()


func __color_title_set(value: Color) -> void:
	color_title = value

	__update_text_credits()


func __color_subtitle_set(value: Color) -> void:
	color_subtitle = value

	__update_text_credits()


func __credits_file_set(value: String) -> void:
	credits_file = value

	__credits_data = __load_credits()

	__update_text_credits()


func __subtitle_set(value: String) -> void:
	subtitle = value

	__update_text_credits()


func __title_set(value: String) -> void:
	title = value

	__update_text_credits()


func __text_with_color(text: String, color: Color) -> String:
	return "[color=#%s]%s[/color]" % [color.to_html(false), text]


func __update_text_credits() -> void:
	var text_credits: RichTextLabel = get_node_or_null("text_credits")
	if !text_credits:
		return

	var text: String = ""

	text += "[center]"
	text += __text_with_color(title, color_title)
	text += "\n"
	text += __text_with_color(subtitle, color_subtitle)
	text += "\n"

	for credit in __credits_data:
		text += "\n"
		text += __text_with_color(credit["role"], color_credit_role)
		text += "\n"
		for name in credit["names"]:
			text += __text_with_color(name, color_credit_name)
			text += "\n"

	text += "[/center]"


	text_credits.bbcode_text = text
