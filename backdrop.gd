extends Node2D
## Original procedural scene. No images, shaders, fonts, network, or imported assets.
var scene_id: String = "arrival"
var motion_time: float = 0.0

const H := 420.0
const W := 1200.0
const GOLD := Color("#e2b77f")
const STEEL := Color("#4f6671")
const INK := Color("#101822")

func quad(a: Vector2,b: Vector2,c: Vector2,d: Vector2,color: Color) -> void:
	draw_colored_polygon(PackedVector2Array([a,b,c,d]),color)

func _draw() -> void:
	# Canvas ends just above the separate dialogue surface.
	for y in range(0,420,3):
		var t := float(y)/H
		draw_rect(Rect2(0,y,W,3),Color("#111a27").lerp(Color("#293a43"),t))
	var exterior := scene_id == "leave" or scene_id == "ending_leave"
	if exterior:
		draw_street()
	else:
		draw_interior()
	draw_vignette()

func draw_street() -> void:
	draw_rect(Rect2(0,221,1200,199),Color("#1b2b37"))
	for i in 12:
		var x := float(i*107)
		var height := float(65+(i*47)%102)
		draw_rect(Rect2(x,230-height,101,height),Color("#17232d").lerp(INK,float(i%4)*0.17))
		for j in 4:
			if (i+j)%3 == 0:
				draw_rect(Rect2(x+12+j*19,250-height,9,18),Color(0.75,0.54,0.33,0.16))
	quad(Vector2(0,303),Vector2(1200,300),Vector2(1200,420),Vector2(0,420),Color("#233641"))
	quad(Vector2(683,265),Vector2(760,265),Vector2(881,420),Vector2(621,420),Color(0.47,0.33,0.24,0.33))
	draw_rect(Rect2(620,55,206,249),Color("#5b5352"))
	draw_rect(Rect2(628,63,190,233),Color("#222e36"))
	draw_rect(Rect2(645,83,156,197),Color("#5e514c"))
	draw_rect(Rect2(655,92,136,177),Color("#ad8968"))
	draw_rect(Rect2(664,102,118,156),Color("#263a45"))
	draw_rect(Rect2(668,108,107,145),Color(0.63,0.52,0.41,0.18))
	draw_line(Vector2(723,105),Vector2(723,262),Color("#46515a"),4)
	draw_line(Vector2(658,174),Vector2(789,174),Color("#46515a"),4)
	if scene_id == "ending_leave": draw_figure(Vector2(721,252),0.69,Color("#162129"),false)
	for i in 16:
		var factor := float((i*43)%100)/100.0
		var center := Vector2(120+float((i*157)%972),315+float((i*19)%96))
		draw_arc(center,9+factor*20,0,PI,20,Color(0.52,0.66,0.68,0.12),1.4)
	draw_rain(Rect2(0,0,W,H),true)

func draw_interior() -> void:
	# Recessed ceiling then an angled tile floor and their reflected geometry.
	quad(Vector2(0,0),Vector2(1200,0),Vector2(1090,102),Vector2(108,102),Color("#17232c"))
	quad(Vector2(69,270),Vector2(1135,270),Vector2(1200,420),Vector2(0,420),Color("#293b43"))
	for i in range(-4,13):
		var x := 55.0+101.0*i
		draw_line(Vector2(598+(x-598)*0.42,273),Vector2(x,420),Color(0.57,0.66,0.61,0.16),1)
	for y in [282,301,330,369,416]:
		draw_line(Vector2(0,y),Vector2(W,y),Color(0.57,0.66,0.61,0.15),1.5)
	draw_line(Vector2(0,271),Vector2(1200,271),Color("#506875"),3)
	for i in 9:
		draw_line(Vector2(0,150+i*13),Vector2(1200,150+i*13),Color(0.59,0.65,0.68,0.05))
	draw_rect(Rect2(121,74,490,8),Color("#50616c"))
	draw_rect(Rect2(126,78,481,3),Color("#c5d6c5"))
	for i in 5:
		quad(Vector2(97-i*8,82),Vector2(630+i*11,82),Vector2(687+i*11,362),Vector2(11-i*10,362),Color(0.69,0.80,0.72,0.014))

	# Wide glass, a narrow inset frame, and a door that only appears in later scenes.
	var aperture := scene_id in ["door","knock","wait","ending_open","ending_stay"]
	var frame := Rect2(725,85,331,226)
	draw_rect(frame.grow(13),Color("#17212d"))
	draw_rect(frame.grow(7),STEEL)
	draw_rect(frame,Color("#24353f"))
	for i in 13:
		var t:=float(i)/12.0
		draw_rect(Rect2(728,90+i*15,325,15),Color("#263f53").lerp(Color("#172533"),t))
	for i in 10:
		var x := 736.0+i*33
		var h := float(41+(i*51)%67)
		draw_rect(Rect2(x,282-h,29,h),Color(0.08,0.14,0.2,0.72))
		if i%2==0: draw_rect(Rect2(x+7,287-h,5,8),Color(0.83,0.61,0.31,0.28))
	draw_rain(frame,false)
	draw_rect(Rect2(885,89,6,218),Color("#63737a"))
	draw_rect(Rect2(729,195,323,4),Color("#566873"))
	draw_line(Vector2(731,93),Vector2(1048,93),Color(0.82,0.79,0.67,0.36),2)
	draw_rect(Rect2(710,308,362,11),Color("#6e7a7c"))
	draw_rect(Rect2(717,318,348,6),Color("#23313a"))
	if aperture:
		var open := scene_id == "ending_open"
		draw_rect(Rect2(914,106,102,197),Color("#1b1f25"))
		draw_rect(Rect2(920,111,90,191),Color("#bb9169"),false,3)
		draw_rect(Rect2(925,117,80,180),Color("#0e1923") if open else Color("#34404a"))
		if not open:
			draw_line(Vector2(935,131),Vector2(935,286),Color(0.82,0.71,0.59,0.28),2)
			draw_circle(Vector2(991,207),3,GOLD)
		else:
			quad(Vector2(927,294),Vector2(1004,294),Vector2(1054,420),Vector2(870,420),Color(0.62,0.45,0.31,0.16))
		if scene_id == "knock" or scene_id == "wait":
			var ripple := fmod(maxf(0.0,motion_time),3.1)/3.1
			draw_arc(Vector2(965,204),10+ripple*29,0,TAU,36,Color(0.84,0.72,0.60,(1-ripple)*0.25),1.1)
		# Final open-door silhouette is physically present; the rest belong only to the glass.
		if scene_id == "ending_open":
			draw_figure(Vector2(966,291),0.96,Color("#080f18"),false)
		elif scene_id != "door":
			draw_figure(Vector2(963,286),0.71,Color(0.06,0.09,0.13,0.72),true)
	elif scene_id == "reflection":
		draw_figure(Vector2(849,277),0.86,Color(0.08,0.12,0.17,0.75),true)
	else:
		draw_figure(Vector2(849,276),0.84,Color(0.13,0.22,0.27,0.24),true)

	for i in range(3,-1,-1):
		draw_machine(Vector2(63+i*156,162+i*5),165-i*8,i)

	# Near foreground bench, rail and paper cup silhouettes.
	quad(Vector2(28,349),Vector2(348,342),Vector2(369,365),Vector2(10,374),Color("#7a675a"))
	quad(Vector2(10,374),Vector2(369,365),Vector2(366,377),Vector2(9,387),Color("#332d2b"))
	draw_rect(Rect2(38,380,11,40),Color("#171d22"))
	draw_rect(Rect2(306,372,11,48),Color("#1a1e22"))
	draw_rect(Rect2(273,334,15,13),Color("#b58f6f"))
	draw_rect(Rect2(272,331,17,4),Color("#e0c9a5"))

func draw_machine(at: Vector2, width: float, index: int) -> void:
	var body := Rect2(at,Vector2(width,138))
	quad(at+Vector2(10,-15),at+Vector2(width-7,-15),at+Vector2(width,0),at,Color("#697e80"))
	draw_rect(body,Color("#475e69"))
	draw_rect(body,Color("#30414c"),false,2)
	draw_rect(Rect2(at+Vector2(3,4),Vector2(width-6,20)),Color("#253941"))
	draw_rect(Rect2(at+Vector2(11,8),Vector2(27,8)),Color("#526875"))
	draw_rect(Rect2(at+Vector2(width-42,8),Vector2(14,7)),Color("#121b21"))
	draw_rect(Rect2(at+Vector2(width-41,9),Vector2(12,5)),Color("#a8b888") if index!=1 else Color("#cca574"))
	draw_circle(at+Vector2(width-15,13),4,Color("#b0beb8"))
	var center := at+Vector2(width*0.49,82)
	draw_circle(center,46,Color("#3a4b53"))
	draw_circle(center,41,Color("#93a5a1"))
	draw_circle(center,35,Color("#17262f"))
	draw_arc(center,39,3.48,5.43,22,Color(0.9,0.95,0.81,0.48),2)
	if index==1:
		var angle := fmod(motion_time*0.58,TAU)
		draw_arc(center,24,angle,angle+2.1,24,Color(0.50,0.65,0.61,0.29),6)
		draw_arc(center,26,angle+PI,angle+PI+1.2,24,Color(0.46,0.54,0.62,0.25),4)
	draw_arc(center+Vector2(-3,1),28,3.55,5.15,18,Color(0.76,0.87,0.82,0.18),3)
	draw_line(at+Vector2(5,134),at+Vector2(width-4,134),Color("#8c9a94"),1.2)

func draw_rain(bounds: Rect2, heavy: bool) -> void:
	var amount := 114 if heavy else 76
	for i in amount:
		var x := bounds.position.x+4+float((i*73+17)%1009)/1009.0*(bounds.size.x-8)
		var offset:=float((i*59+17)%1013)/1013.0
		var speed:=46.0+float(i%6)*12.0
		var y:=bounds.position.y+fposmod(offset*bounds.size.y+motion_time*speed,bounds.size.y)
		var length:=minf(7+float((i*13)%20),bounds.end.y-y)
		draw_line(Vector2(x,y),Vector2(maxf(bounds.position.x,x-length*0.25),y+length),Color(0.61,0.73,0.77,0.13+float(i%4)*0.036),1)

func draw_figure(foot: Vector2, sizing: float, color: Color, reflection: bool) -> void:
	var lean := -9.0 if reflection else 0.0
	draw_circle(foot+Vector2(lean,-144)*sizing,17*sizing,color)
	var shape := PackedVector2Array([
		foot+Vector2(-21+lean,-123)*sizing,foot+Vector2(15+lean,-124)*sizing,
		foot+Vector2(31,-97)*sizing,foot+Vector2(33,-25)*sizing,
		foot+Vector2(19,-20)*sizing,foot+Vector2(15,0)*sizing,
		foot+Vector2(2,0)*sizing,foot+Vector2(-7,-48)*sizing,
		foot+Vector2(-18,0)*sizing,foot+Vector2(-30,0)*sizing,
		foot+Vector2(-26,-63)*sizing,foot+Vector2(-35,-45)*sizing,
		foot+Vector2(-42,-56)*sizing,foot+Vector2(-33,-104)*sizing])
	draw_colored_polygon(shape,color)

func draw_vignette() -> void:
	for i in 15:
		var alpha := (1.0-float(i)/15.0)*0.08
		draw_rect(Rect2(i*7,0,7,H),Color(0.032,0.047,0.070,alpha))
		draw_rect(Rect2(W-i*7-7,0,7,H),Color(0.032,0.047,0.070,alpha))
	for i in 12:
		var alpha := (1.0-float(i)/12.0)*0.19
		draw_rect(Rect2(0,H-i*5-5,W,5),Color(0.032,0.047,0.070,alpha))
