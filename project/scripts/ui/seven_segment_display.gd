extends Control
class_name SevenSegmentDisplay

@export var active_color: Color = Color.GREEN
@export var inactive_color: Color = Color.DARK_GREEN

@onready var segments: Array[TextureRect] = [$SegmentA,$SegmentB,$SegmentC,$SegmentD,$SegmentE,$SegmentF,$SegmentG]

func _ready():
	update_display()

var chr: String = " ":
	set(value):
		chr = value
		update_display()

func set_segments(values: Array[bool]):
	for i in range(7):
		segments[i].modulate = active_color if values[i] else inactive_color

func update_display():
	match chr:
		" ": set_segments([false,false,false,false,false,false,false])
		"0": set_segments([true,true,true,true,true,true,false])
		"1": set_segments([false,true,true,false,false,false,false])
		"2": set_segments([true,true,false,true,true,false,true])
		"3": set_segments([true,true,true,true,false,false,true])
		"4": set_segments([false,true,true,false,false,true,true])
		"5": set_segments([true,false,true,true,false,true,true])
		"6": set_segments([true,false,true,true,true,true,true])
		"7": set_segments([true,true,true,false,false,false,false])
		"8": set_segments([true,true,true,true,true,true,true])
		"9": set_segments([true,true,true,false,false,true,true])
