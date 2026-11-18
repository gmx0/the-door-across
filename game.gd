extends Node2D
# Original standalone fiction. No network, personal data, save files or imported art.
const STORY = {
"arrival": {"who":"11:47 PM · LAST WASH", "text":"The laundromat is empty except for you. Rain stitches the windows shut. Your dryer has six minutes left.\nAcross the room, a person-shaped shadow rests against a door marked STAFF ONLY. There is no person in front of it. The ceiling light is directly above the door. The shadow reaches toward the light.", "choices":[["Check the reflection in the window.","reflection"],["Look closely at the staff door.","door"]]},
"reflection": {"who":"THE WINDOW", "text":"The window reflects the rows of machines, your empty basket, and you. It does not reflect the staff door. In its place is a bright rectangle of afternoon sky.\nThe shadow has moved beside your reflection. It lifts a hand. Your reflection lifts its hand too. You keep both hands on the basket.", "choices":[["Ask who is on the other side.","knock"],["Wait for the dryer to finish.","wait"]]},
"door": {"who":"THE STAFF DOOR", "text":"The paint around the handle is worn smooth. Beneath STAFF ONLY, someone has scratched a smaller message: LEAVE ROOM.\nNot 'leave the room.' Just 'leave room.'\nA wet footprint appears on your side of the threshold. Then another, pointing back toward the door. The shadow remains perfectly dry.", "choices":[["Knock once.","knock"],["Take your basket to the exit.","leave"]]},
"knock": {"who":"THREE INCHES OF WOOD", "text":"Before you can finish, something answers from inside the dryer. One knock. The staff door answers a moment later.\nA voice, very close to your ear, says: 'I only need somewhere to stand.'\nThe handle turns a little. The shadow thins until it could slip between two pages. It waits for you to decide what a door is for.", "choices":[["Open the staff door.","ending_open"],["Leave room on the bench instead.","wait"]]},
"wait": {"who":"THE EMPTY SEAT", "text":"You move your basket off the bench. The shadow folds itself into the space beside you. No cushion sinks.\nFor a while there is only rain and the heavy, ordinary tumbling of clothes. Then the dryer stops. Its display reads THANK YOU, although the display has only four digits.\nThe street outside is dark again. The shadow has not moved.", "choices":[["Stay beside it until the rain ends.","ending_stay"],["Collect your clothes and leave.","leave"]]},
"leave": {"who":"THE FRONT EXIT", "text":"Your clothes are warm. You count every sleeve before putting them in the basket. There are no extra ones.\nAt the front door, your reflection reaches for the handle a heartbeat before you do. Behind it, the shadow stands politely aside.\nYou could call back. You could ask which of you is being allowed to go. The rain gives you an excuse not to.", "choices":[["Step into the rain without looking back.","ending_leave"],["Turn back and offer the empty seat.","ending_stay"]]},
"ending_open": {"who":"ENDING 1 OF 3 · A PLACE TO STAND", "text":"You open the staff door onto afternoon. Somewhere, a child calls someone else's name. The shadow steps through and becomes a person too far away to recognize.\nYou shut the door. The dryer finishes. Everything is ordinary.\nOutside, under the streetlamp, you turn to check your own shadow. It is still inside, holding the door for the next arrival.", "choices":[["Begin again.","arrival"]]},
"ending_stay": {"who":"ENDING 2 OF 3 · THE SECOND CHAIR", "text":"You sit until the rain loosens into separate drops. Beside you, the shadow becomes less like a person and more like an absence that no longer needs explaining.\nWhen morning reaches the windows, the seat is empty. On it lies one dry sock, neatly folded. It is not yours.\nYou leave it there. Some things are easier to find when someone has kept a place for them.", "choices":[["Begin again.","arrival"]]},
"ending_leave": {"who":"ENDING 3 OF 3 · NOTHING FOLLOWED", "text":"You walk home in the rain. At every crossing, your shadow falls exactly where the streetlights say it should. Nothing follows you.\nThe next evening, the laundromat is a vacant storefront. A faded sign advertises a business that closed years ago. You still have your clean clothes.\nOne pocket contains a receipt: ONE SPACE RESERVED. No date. No price. You do not throw it away.", "choices":[["Begin again.","arrival"]]}
}
var scene_id="arrival"
var history: Array[String]=[]
var motion_time=0.0
var reduced_motion=false
var backdrop: Node2D
var heading: Label
var prose: Label
var progress: Label
var choices: Array[Button]=[]
var motion_button: Button
var failures=0

func _ready():
	if ResourceLoader.exists("res://backdrop.gd"):
		backdrop=Node2D.new(); backdrop.set_script(load("res://backdrop.gd")); add_child(backdrop)
	build_ui()
	show_scene("arrival")
	if "--test" in OS.get_cmdline_user_args(): call_deferred("smoke_test")

func build_ui():
	var layer=CanvasLayer.new(); add_child(layer)
	var panel=ColorRect.new(); panel.position=Vector2(0,420); panel.size=Vector2(1200,340); panel.color=Color("101920"); layer.add_child(panel)
	heading=Label.new(); heading.position=Vector2(65,442); heading.size=Vector2(1060,35); heading.add_theme_font_size_override("font_size",19); heading.modulate=Color("dbc7a2"); layer.add_child(heading)
	prose=Label.new(); prose.position=Vector2(65,482); prose.size=Vector2(1070,176); prose.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; prose.add_theme_font_size_override("font_size",20); layer.add_child(prose)
	for i in 2:
		var b=Button.new(); b.position=Vector2(65+i*550,675); b.size=Vector2(535,48); b.add_theme_font_size_override("font_size",18); b.pressed.connect(func(): choose(i)); layer.add_child(b); choices.append(b)
	var title=Label.new(); title.text="THE DOOR ACROSS"; title.position=Vector2(38,20); title.add_theme_font_size_override("font_size",26); layer.add_child(title)
	progress=Label.new(); progress.position=Vector2(38,58); progress.add_theme_font_size_override("font_size",16); layer.add_child(progress)
	var restart=Button.new(); restart.text="Restart [R]"; restart.position=Vector2(1020,20); restart.size=Vector2(145,38); restart.pressed.connect(restart_story); layer.add_child(restart)
	motion_button=Button.new(); motion_button.position=Vector2(960,68); motion_button.size=Vector2(205,34); motion_button.pressed.connect(toggle_motion); layer.add_child(motion_button); update_motion_text()
	var help=Label.new(); help.text="1 / 2 or click: choose    Tab + Enter: keyboard navigation    R: restart    M: reduce motion"; help.position=Vector2(65,734); help.add_theme_font_size_override("font_size",14); help.modulate=Color("9eafb9"); layer.add_child(help)

func show_scene(id: String):
	scene_id=id
	heading.text=STORY[id].who; prose.text=STORY[id].text
	for i in choices.size():
		choices[i].visible=i<STORY[id].choices.size()
		if choices[i].visible: choices[i].text="%d. %s" % [i+1,STORY[id].choices[i][0]]
	progress.text="A short story in choices · Fiction · No sound required"
	if backdrop!=null: backdrop.scene_id=id; backdrop.queue_redraw()
	queue_redraw()

func choose(index: int):
	if index<0 or index>=STORY[scene_id].choices.size(): return
	var destination=STORY[scene_id].choices[index][1]
	if destination=="arrival": restart_story(); return
	history.append(scene_id)
	show_scene(destination)

func restart_story():
	history.clear(); motion_time=0
	show_scene("arrival")

func toggle_motion():
	reduced_motion=not reduced_motion; update_motion_text()
func update_motion_text(): motion_button.text="Motion: %s [M]" % ("still" if reduced_motion else "gentle")

func _unhandled_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1,KEY_KP_1: choose(0)
			KEY_2,KEY_KP_2: choose(1)
			KEY_R: restart_story()
			KEY_M: toggle_motion()

func _process(delta):
	if not reduced_motion: motion_time+=minf(delta,0.1)
	if backdrop!=null:
		backdrop.motion_time=motion_time; backdrop.queue_redraw()

func check(ok: bool, message: String):
	if not ok: failures+=1; push_error(message)
func press(key: int):
	var event=InputEventKey.new(); event.keycode=key; event.pressed=true; get_viewport().push_input(event)
	event.pressed=false; get_viewport().push_input(event)
func click(at: Vector2):
	var motion=InputEventMouseMotion.new(); motion.position=at; motion.global_position=at; get_viewport().push_input(motion,true)
	var event=InputEventMouseButton.new(); event.position=at; event.global_position=at; event.button_index=MOUSE_BUTTON_LEFT; event.button_mask=MOUSE_BUTTON_MASK_LEFT; event.pressed=true; get_viewport().push_input(event,true)
	event.button_mask=0; event.pressed=false; get_viewport().push_input(event,true)
func complete_routes(id: String, keys: Array) -> Array:
	if id.begins_with("ending_"): return [{"keys":keys,"ending":id}]
	var routes: Array=[]
	for i in STORY[id].choices.size():
		var next_keys=keys.duplicate(); next_keys.append(KEY_1 if i==0 else KEY_2)
		routes.append_array(complete_routes(STORY[id].choices[i][1],next_keys))
	return routes

func smoke_test():
	set_process(false)
	await get_tree().process_frame
	var routes=complete_routes("arrival",[])
	for route in routes:
		press(KEY_R)
		for key in route.keys: press(key)
		check(scene_id==route.ending,"Keyboard path failed: "+route.ending)
		press(KEY_2); check(scene_id==route.ending,"Hidden ending option accepted")
		press(KEY_1); check(scene_id=="arrival" and history.is_empty(),"Ending restart failed")
	# Native Button events through viewport: arrival->door->leave->ending_leave.
	for at in [Vector2(800,699),Vector2(800,699),Vector2(300,699)]:
		click(at)
	check(scene_id=="ending_leave","Mouse ending path failed")
	click(Vector2(1080,39)); check(scene_id=="arrival" and history.is_empty(),"Mouse restart failed")
	press(KEY_M); var old=motion_time; _process(1); check(motion_time==old,"Reduced motion still animates")
	press(KEY_M); _process(0.1); check(motion_time>old,"Motion did not resume")
	for id in STORY:
		show_scene(id)
		await get_tree().process_frame
		check(prose.get_minimum_size().y<=176,"Story text overflows panel: "+id)
		for option in STORY[id].choices: check(STORY.has(option[1]),"Broken destination")
	if failures==0: print("THE DOOR ACROSS TEST PASSED: all %d routes, three endings, keyboard/mouse viewport input, restart, motion control, story links and text fit" % routes.size())
	get_tree().quit(1 if failures else 0)
