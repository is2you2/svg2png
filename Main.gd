extends CenterContainer


var os_name:= OS.get_name()


func _ready():
	get_tree().connect("files_dropped", self,"drag_drop_catch")


func drag_drop_catch(files:PoolStringArray, scr:int):
	for file in files:
		# 파일 경로로부터 폴더구조와 파일, 확장자를 분리
		var sep:int = file.find_last('\\' if os_name == 'Windows' else '/') + 1
		var _path:String = file.substr(0, sep)
		var _filename:String = file.substr(sep)
		var _ext_sep:= _filename.find_last('.')
		var _exactly_name:= _filename.substr(0, _ext_sep)
		var _ext:= _filename.substr(_ext_sep)
		# 파일이 svg인지 확인하기
		if _ext != '.svg':
			$vbox/progress.bbcode_text += '\n[color=#faf]%s: %s[/color]' % ['이 파일은 무시합니다', '확장자 안맞음, ' + _ext]
			continue
		# 이미지로 해당 파일 불러오기
		var img:= Image.new()
		img.load(file)
		img.save_png(_path + _exactly_name + '.png')
		$vbox/progress.bbcode_text += '\n[color=#afa]%s: %s[/color]' % ['잘 처리 되었습니다', _filename]


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
