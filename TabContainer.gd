@tool
extends TabContainer


@export var generated_theme:Theme

@export var generate_now:bool = false:
	set(new_value):
		if new_value == true:
			generate()
			print("generating...")


func generate():
	
	var new_theme := theme.duplicate(true)
	
	# Duplicating Icon start!!
	var icon_address := []
	for icon_type in theme.get_icon_type_list():
		new_theme.add_type(icon_type)
		for icon_name in theme.get_icon_list(icon_type):
			icon_address.append([icon_type,icon_name])
	
	for icon_path in icon_address:
		var icon_type:String = icon_path[0]
		var icon_name:String = icon_path[1]
		
		new_theme.set_icon(icon_name,icon_type, launder_texture(theme.get_icon(icon_name,icon_type)) )
	# duplicating icon end
	
	# duplicating texture style start
	var style_address := []
	for style_type in theme.get_stylebox_type_list():
		new_theme.add_type(style_type)
		for style_name in theme.get_stylebox_list(style_type):
			if not theme.get_stylebox(style_name,style_type) is StyleBoxTexture:
				continue
			style_address.append([style_type,style_name])
	
	for style_path in style_address:
		var style_type = style_path[0]
		var style_name = style_path[1]
		
		var stylebox:StyleBoxTexture = theme.get_stylebox(style_name,style_type).duplicate(true)
		stylebox.texture = launder_texture(stylebox.texture)
		
		new_theme.set_stylebox(style_name,style_type,stylebox)
	# duplicating texture style end
	
	generated_theme = new_theme


func launder_texture(texture:Texture2D) -> Texture2D:
	var image := texture.get_image()
	var image_data := image.get_data()
	var image_width := image.get_width()
	var image_height := image.get_height()
	
	var new_image := Image.new()
	new_image.set_data(image_width,image_height,false,Image.FORMAT_RGBA8,image_data)
	
	var new_texture := ImageTexture.create_from_image(new_image)
	return new_texture
