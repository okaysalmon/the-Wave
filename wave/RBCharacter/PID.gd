extends RefCounted
class_name Pid3D

var _p:float
var _i:float
var _d:float

var _prev_error:Vector3
var _error_intergral:Vector3

func _init(p: float, i:float, d:float) -> void:
	_p = p
	_i = i
	_d = d

func update(error:Vector3, delta:float)->Vector3:
	#print(_error_intergral)
	_error_intergral += error * delta
	var error_derivative = (error - _prev_error)/delta
	_prev_error = error
	#print(str(error_derivative)+str(_error_intergral),str(error)+str(_d)+str(_i)+str(_p))
	#print(str(_p)+" * "+str(error)+" + "+str(_i)+" * "+str(_error_intergral)+" + "+str(_d)+" * "+str(error_derivative))
	return _p * error + _i * _error_intergral + _d* error_derivative
