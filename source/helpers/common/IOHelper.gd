class_name IOHelper


# Private constants

const __OUTPUT_RELATIVE: String = "user://"


# Public methods

static func directory_create(path: String, relative: bool = true) -> bool:
	var normalized_path: String = __normalize_path(path, relative)

	var directory: Directory = Directory.new()

	var result: int = directory.make_dir_recursive(normalized_path)
	if result != OK:
		# TODO: Add logger
		return false

	return true


# Hi, you are awesome Velop. - Lil'Oni
static func directory_exists(path: String, relative: bool = true) -> bool:
	var normalized_path: String = __normalize_path(path, relative)

	var directory: Directory = Directory.new()

	return directory.dir_exists(path)


static func directory_list_files(path: String, relative: bool = true) -> Array:
	var normalized_path: String = __normalize_path(path, relative)

	var directory: Directory = Directory.new()

	if !directory.dir_exists(normalized_path):
		return []

	var result: int = directory.open(normalized_path)
	if result != OK:
		# TODO: Add logger

		return []

	directory.list_dir_begin(true, false)

	var files: Array = []

	var file: String = directory.get_next()
	while file != "":
		if directory.file_exists(file):
			files.append(file)

		file = directory.get_next()

	directory.list_dir_end()

	return files


static func file_delete(path: String, relative: bool = true) -> bool:
	var normalized_path: String = __normalize_path(path, relative)

	var directory: Directory = Directory.new()

	var result: int = directory.remove(normalized_path)
	if result != OK:
		# TODO: Add logger

		return false

	return true


static func file_exists(path: String, relative: bool = true) -> bool:
	var normalized_path: String = __normalize_path(path, relative)

	var file: File = File.new()

	return file.file_exists(normalized_path)


static func file_load(path: String, relative: bool = true) -> String:
	var normalized_path: String = __normalize_path(path, relative)

	var file: File = File.new()

	var result: int = file.open(normalized_path, File.READ)
	if result != OK:
		# TODO: Add logger

		return ""

	var content: String = file.get_as_text()
	file.close()

	return content


static func file_save(content: String, path: String, relative: bool = true) -> bool:
	var normalized_path: String = __normalize_path(path, relative)

	var file: File = File.new()

	var result: int = file.open(normalized_path, File.WRITE)
	if result != OK:
		# TODO: Add logger

		return false

	file.store_string(content)
	file.close()

	return true


# Private methods

static func __normalize_path(path: String, relative: bool) -> String:
	if relative:
		return __OUTPUT_RELATIVE + path

	return path
