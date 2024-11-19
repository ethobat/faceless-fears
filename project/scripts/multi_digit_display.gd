extends Node
class_name MultiDigitDisplay

@export var active_color: Color = Color.GREEN
@export var inactive_color: Color = Color.DARK_GREEN

@export var displays_before_point: Array[SevenSegmentDisplay]
@export var displays_after_point: Array[SevenSegmentDisplay]
@export var overflow_indicator: Label

@export var num: float = 9124.836:
	set(value):
		num = value
		refresh()

func _ready():
	refresh()

func refresh():
	var fullstr: String = str(num)
	if not fullstr.contains("."):
		fullstr += ".0"
	var point = fullstr.find(".")
	var start = point - len(displays_before_point)
	var end = point + len(displays_after_point)
	#print(fullstr)
	#print(str(start) + " - " + str(point) + " - " + str(end))
	start = max(start,0)
	var before = fullstr.substr(start, point-start)
	var after = fullstr.substr(point+1, end-point)
	for i in range(len(displays_before_point)-len(before)):
		before = "0" + before
	for i in range(len(displays_after_point)-len(after)):
		after = after + "0"
	#print(before + "." + after)
	for i in range(len(before)):
		displays_before_point[i].chr = before[i]
	for i in range(len(after)):
		displays_after_point[i].chr = after[i]
	overflow_indicator.label_settings.font_color = active_color if start > 0 else inactive_color
	#print("------")
