extends Button

var highlighted: bool = false:
	set(value):
		highlighted = value
		update_text()

var non_highlighted_text: String
var highlighted_text: String

func _ready():
	non_highlighted_text = text
	highlighted_text = "== " + non_highlighted_text + " =="

func update_text():
	if highlighted:
		text = highlighted_text
	else:
		text = non_highlighted_text

func highlight():
	highlighted = true
	
func unhighlight():
	highlighted = false
