class_name EnumHelpers

static func toString(enum_full: Dictionary[String, int], enum_value: int) -> String:
	return enum_full.keys()[enum_value]
