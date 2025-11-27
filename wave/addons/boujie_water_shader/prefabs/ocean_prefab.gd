@tool
extends Ocean

## Emitted when level-of-detail settings are updated.
## This signal may fire in the editor. Make sure any connected scripts are also tool scripts.
signal updated_lod(far_distance: float, middle_distance: float, unit_size: float)


func _on_water_material_designer_updated_lod(far_distance, middle_distance, unit_size):
	updated_lod.emit(far_distance, middle_distance, unit_size)

## adding the below to try and link the wave hieght to somthibg i can grab

@onready var ocean_material:Material =  self.material    
@onready var water_level_y: float = self.global_position.y           # base level of the ocean plane

var time:float = 0.0

func _process(_delta):
	time += _delta
	material.set_shader_parameter("wave_time",time)


const TAU := PI * 2.0

func _gerstner_offset(
	x: float, z: float, t: float,
	steepness: float, amplitude: float,
	dir_deg: float, freq: float,
	speed: float, phase_deg: float
) -> Vector3:
	var dir := Vector2(
		sin(dir_deg * TAU / 360.0),
		cos(dir_deg * TAU / 360.0)
	)
	var p := phase_deg * TAU / 360.0
	var arg := TAU * freq * dir.dot(Vector2(x, z)) + speed * (t + p)

	var result := Vector3.ZERO
	result.x = (steepness * amplitude) * dir.x * cos(arg)
	result.y = steepness * sin(arg)
	result.z = (steepness * amplitude) * dir.y * cos(arg)
	return result


func get_wave_height_at(global_x: float, global_z: float)-> float:
	if ocean_material == null:
		return water_level_y

	var count: int = ocean_material.get_shader_parameter("WaveCount")
	if count <= 0:
		return water_level_y

	var steepnesses: PackedFloat32Array = ocean_material.get_shader_parameter("WaveSteepnesses")
	var amplitudes: PackedFloat32Array = ocean_material.get_shader_parameter("WaveAmplitudes")
	var dirs: PackedFloat32Array       = ocean_material.get_shader_parameter("WaveDirectionsDegrees")
	var freqs: PackedFloat32Array      = ocean_material.get_shader_parameter("WaveFrequencies")
	var speeds: PackedFloat32Array     = ocean_material.get_shader_parameter("WaveSpeeds")
	var phases: PackedFloat32Array     = ocean_material.get_shader_parameter("WavePhases")

	var sum := Vector3.ZERO
	for i in count:
		sum += _gerstner_offset(
			global_x, global_z, time,
			steepnesses[i], amplitudes[i],
			dirs[i], freqs[i], speeds[i], phases[i]
		)

	sum /= float(count)
	return water_level_y + sum.y
