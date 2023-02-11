extends Sprite

onready var viewport = prepare_viewport()
onready var cam = $"/root/Main/Player/Camera"

var last_viewport_size: Vector2 = get_canvas_transform().get_scale()


func _ready():
	refresh()
	
	# Move this node into Main
	# (If we just called these methods, it'd say "busy setting up children,
	# remove_node() failed. Consider using call_deferred(...) instead.")
	get_parent().call_deferred("remove_child", self)
	$"/root/Main".call_deferred("add_child", self)


func _process(_delta):
	# When window size changes, resize viewport texture.
	if get_canvas_transform().get_scale() != last_viewport_size:
		refresh()
	
	viewport.canvas_transform = get_canvas_transform()
	# Set the position to the screen center
	scale = Vector2(1, 1) / cam.get_canvas_transform().get_scale()
	position = (viewport.size / 2 - cam.get_canvas_transform().origin) * scale
	# Update shader pixel scale so the bubble outline is independent of viewport res
	material.set_shader_param("zoom", cam.zoom.x * 1.5 )


func refresh():
	# Set the viewport size to the window size
	viewport.size = OS.window_size
	# Create a new texture for self
	var tex = ImageTexture.new()
	tex.create(viewport.size.x, viewport.size.y, Image.FORMAT_RGB8)
	texture = tex
	# Now give the shader our viewport texture
	material.set_shader_param("viewport_texture", viewport.get_texture())


# Fetch any viewports that have been moved into Main.
# If there are none, move this object's parent viewport into Main.
func prepare_viewport() -> Viewport:
	var my_viewport = $"../SprayViewport"
	
	if $"/root/Main".has_node("SprayViewport"):
		# Viewport exists in main.
		var global_viewport: Viewport = $"/root/Main/SprayViewport"
		
		# Move spray particles to the global viewport.
		var my_particles = my_viewport.get_node("SprayParticles")
		my_viewport.call_deferred("remove_child", my_particles)
		global_viewport.call_deferred("add_child", my_particles)
		# Delete local viewport so we don't have extras.
		my_viewport.queue_free()
		
		return global_viewport
	else:
		# No viewport exists in main.
		# Move this node's parent viewport into main.
		my_viewport.get_parent().call_deferred("remove_child", my_viewport)
		$"/root/Main".call_deferred("add_child", my_viewport)
		
		return my_viewport
