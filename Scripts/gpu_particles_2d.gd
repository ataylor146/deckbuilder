class_name Confetti
extends GPUParticles2D
## Attach to a GPUParticles2D node (Godot 4.2+).
## Call burst() to fire the confetti. Everything is built in code,
## so no textures or materials are needed.

@export var colors: Array[Color] = [
	Color("#ff4d6d"), Color("#ffb703"), Color("#ffd60a"),
	Color("#4cc9f0"), Color("#4361ee"), Color("#7bf1a8"),
	Color("#b5179e"), Color.WHITE,
]
@export var piece_count: int = 150
@export var burst_speed: Vector2 = Vector2(500, 1000)
@export var burst_spread: float = 55.0 ## degrees either side of "up"


func _ready() -> void:
	amount = piece_count
	lifetime = 3.5
	one_shot = true
	explosiveness = 1.0
	emitting = false
	texture = _make_piece_texture()
	process_material = _make_material()
	rain()


## Fire the confetti. Call as often as you like.
func burst() -> void:
	restart()
	emitting = true

func rain(width: float = 1152.0, height: float = 648.0) -> void:
	var m := process_material as ParticleProcessMaterial
	m.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	m.emission_box_extents = Vector3(width / 2.0, 1, 1)
	m.direction = Vector3(0, 1, 0)       # fall downward
	m.spread = 15.0
	m.initial_velocity_min = 50.0
	m.initial_velocity_max = 150.0
	m.gravity = Vector3(0, 120, 0)       # gentle pull
	m.damping_min = 0.0                  # no braking, since this isn't a burst
	m.damping_max = 0.0

	lifetime = 7.0                       # long enough to cross the screen
	amount = 200
	one_shot = false
	explosiveness = 0.0                  # spread spawns evenly over time
	preprocess = lifetime                # screen is already full on the first frame
	visibility_rect = Rect2(-width / 2.0, 0, width, height + 200)
	emitting = true

func _make_piece_texture() -> ImageTexture:
	# A small white rectangle; colour comes from the particle material.
	var img := Image.create(8, 14, false, Image.FORMAT_RGBA8)
	img.fill(Color.WHITE)
	return ImageTexture.create_from_image(img)


func _make_material() -> ParticleProcessMaterial:
	var m := ParticleProcessMaterial.new()

	# Shoot upward in a cone
	m.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_POINT
	m.direction = Vector3(0, 1, 0)
	m.spread = burst_spread
	m.initial_velocity_min = burst_speed.x
	m.initial_velocity_max = burst_speed.y

	# Gravity plus heavy damping = fast pop, then slow floaty fall
	m.gravity = Vector3(0, 500, 0)
	m.damping_min = 180.0
	m.damping_max = 320.0

	# Tumbling
	m.angle_min = 0.0
	m.angle_max = 360.0
	m.angular_velocity_min = -540.0
	m.angular_velocity_max = 540.0

	# Size variety
	m.scale_min = 0.6
	m.scale_max = 1.5

	# Random colour per piece: a hard-stepped gradient sampled at random
	var grad := Gradient.new()
	grad.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	var n := colors.size()
	var offs := PackedFloat32Array()
	for i in n:
		offs.append(float(i) / n)
	grad.offsets = offs
	grad.colors = PackedColorArray(colors)
	var color_tex := GradientTexture1D.new()
	color_tex.gradient = grad
	m.color_initial_ramp = color_tex

	# Fade out over the last 20% of life
	var fade := Gradient.new()
	fade.offsets = PackedFloat32Array([0.0, 0.8, 1.0])
	fade.colors = PackedColorArray([Color.WHITE, Color.WHITE, Color(1, 1, 1, 0)])
	var fade_tex := GradientTexture1D.new()
	fade_tex.gradient = fade
	m.color_ramp = fade_tex

	return m
