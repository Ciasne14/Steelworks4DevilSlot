extends Node  # Jeśli masz Node2D jako główny węzeł

@export var symbols : Array # Tablica z symbolami (np. lista nazw plików PNG)
@export var num_reels = 5
@export var row_reels = 4 # Liczba bębnów
@export var reel_speed = 10 # Prędkość obracania bębnów
@export var stop_delay = 0.5 # Opóźnienie przed zatrzymaniem bębna
@export var tickets = 100

@onready var camera : Camera2D = $Camera2D  # Reference to the Camera2D node
var shake_duration : float = 0.1  # Duration of the shake
var shake_intensity : float = 10.0  # How strong the shake will be (adjust as needed)
var shake_timer : float = 0.0  # Timer to control shake duration
var original_position : Vector2  # To store the camera's original position

var last_won = 0
@onready var spin_button:=$Button

@export var last_particle: PackedScene


# Ścieżka do folderu ze sprite'ami
var folder_path : String = "res://Assets/Colored/"
var sprites : Array = [
	preload("res://Assets/Colored/genericItem_color_001.png"),
	preload("res://Assets/Colored/genericItem_color_002.png"),
	preload("res://Assets/Colored/genericItem_color_003.png"),
	preload("res://Assets/Colored/genericItem_color_004.png"),
	preload("res://Assets/Colored/genericItem_color_005.png"),
	preload("res://Assets/Colored/genericItem_color_006.png"),
	preload("res://Assets/Colored/genericItem_color_007.png"),
	preload("res://Assets/Colored/genericItem_color_008.png"),
	preload("res://Assets/Colored/genericItem_color_009.png"),
	preload("res://Assets/Colored/genericItem_color_010.png"),
	preload("res://Assets/Colored/genericItem_color_011.png"),
	preload("res://Assets/Colored/genericItem_color_012.png"),
	preload("res://Assets/Colored/genericItem_color_013.png"),
	preload("res://Assets/Colored/genericItem_color_013.png"),
		preload("res://Assets/Colored/genericItem_color_014.png"),
		preload("res://Assets/Colored/genericItem_color_015.png"),
		preload("res://Assets/Colored/genericItem_color_016.png"),
		preload("res://Assets/Colored/genericItem_color_017.png"),
		preload("res://Assets/Colored/genericItem_color_018.png"),
		preload("res://Assets/Colored/genericItem_color_019.png"),
		preload("res://Assets/Colored/genericItem_color_020.png"),
		preload("res://Assets/Colored/genericItem_color_021.png"),
		preload("res://Assets/Colored/genericItem_color_022.png"),
		preload("res://Assets/Colored/genericItem_color_023.png"),
		preload("res://Assets/Colored/genericItem_color_024.png"),
		preload("res://Assets/Colored/genericItem_color_025.png"),
		preload("res://Assets/Colored/genericItem_color_026.png"),
		preload("res://Assets/Colored/genericItem_color_027.png"),
		preload("res://Assets/Colored/genericItem_color_028.png"),
		preload("res://Assets/Colored/genericItem_color_029.png"),
		preload("res://Assets/Colored/genericItem_color_030.png"),
		preload("res://Assets/Colored/genericItem_color_031.png"),
		preload("res://Assets/Colored/genericItem_color_032.png"),
		preload("res://Assets/Colored/genericItem_color_033.png"),
		preload("res://Assets/Colored/genericItem_color_034.png"),
		preload("res://Assets/Colored/genericItem_color_035.png"),
		preload("res://Assets/Colored/genericItem_color_036.png"),
		preload("res://Assets/Colored/genericItem_color_037.png"),
		preload("res://Assets/Colored/genericItem_color_038.png"),
		preload("res://Assets/Colored/genericItem_color_039.png"),
		preload("res://Assets/Colored/genericItem_color_040.png"),
		preload("res://Assets/Colored/genericItem_color_041.png"),
		preload("res://Assets/Colored/genericItem_color_042.png"),
		preload("res://Assets/Colored/genericItem_color_043.png"),
		preload("res://Assets/Colored/genericItem_color_044.png"),
		preload("res://Assets/Colored/genericItem_color_045.png"),
		preload("res://Assets/Colored/genericItem_color_046.png"),
		preload("res://Assets/Colored/genericItem_color_047.png"),
		preload("res://Assets/Colored/genericItem_color_048.png"),
		preload("res://Assets/Colored/genericItem_color_049.png"),
		preload("res://Assets/Colored/genericItem_color_050.png"),
		preload("res://Assets/Colored/genericItem_color_051.png"),
		preload("res://Assets/Colored/genericItem_color_052.png"),
		preload("res://Assets/Colored/genericItem_color_053.png"),
		preload("res://Assets/Colored/genericItem_color_054.png"),
		preload("res://Assets/Colored/genericItem_color_055.png"),
		preload("res://Assets/Colored/genericItem_color_056.png"),
		preload("res://Assets/Colored/genericItem_color_057.png"),
		preload("res://Assets/Colored/genericItem_color_058.png"),
		preload("res://Assets/Colored/genericItem_color_059.png"),
		preload("res://Assets/Colored/genericItem_color_060.png"),
		preload("res://Assets/Colored/genericItem_color_061.png"),
		preload("res://Assets/Colored/genericItem_color_062.png"),
		preload("res://Assets/Colored/genericItem_color_063.png"),
		preload("res://Assets/Colored/genericItem_color_064.png"),
		preload("res://Assets/Colored/genericItem_color_065.png"),
		preload("res://Assets/Colored/genericItem_color_066.png"),
		preload("res://Assets/Colored/genericItem_color_067.png"),
		preload("res://Assets/Colored/genericItem_color_068.png"),
		preload("res://Assets/Colored/genericItem_color_069.png"),
		preload("res://Assets/Colored/genericItem_color_070.png"),
		preload("res://Assets/Colored/genericItem_color_071.png"),
		preload("res://Assets/Colored/genericItem_color_072.png"),
		preload("res://Assets/Colored/genericItem_color_073.png"),
		preload("res://Assets/Colored/genericItem_color_074.png"),
		preload("res://Assets/Colored/genericItem_color_075.png"),
		preload("res://Assets/Colored/genericItem_color_076.png"),
		preload("res://Assets/Colored/genericItem_color_077.png"),
		preload("res://Assets/Colored/genericItem_color_078.png"),
		preload("res://Assets/Colored/genericItem_color_079.png"),
		preload("res://Assets/Colored/genericItem_color_080.png"),
		preload("res://Assets/Colored/genericItem_color_081.png"),
		preload("res://Assets/Colored/genericItem_color_082.png"),
		preload("res://Assets/Colored/genericItem_color_083.png"),
		preload("res://Assets/Colored/genericItem_color_084.png"),
		preload("res://Assets/Colored/genericItem_color_085.png"),
		preload("res://Assets/Colored/genericItem_color_086.png"),
		preload("res://Assets/Colored/genericItem_color_087.png"),
		preload("res://Assets/Colored/genericItem_color_088.png"),
		preload("res://Assets/Colored/genericItem_color_089.png"),
		preload("res://Assets/Colored/genericItem_color_090.png"),
		preload("res://Assets/Colored/genericItem_color_091.png"),
		preload("res://Assets/Colored/genericItem_color_092.png"),
		preload("res://Assets/Colored/genericItem_color_093.png"),
		preload("res://Assets/Colored/genericItem_color_094.png"),
		preload("res://Assets/Colored/genericItem_color_095.png"),
		preload("res://Assets/Colored/genericItem_color_096.png"),
		preload("res://Assets/Colored/genericItem_color_097.png"),
		preload("res://Assets/Colored/genericItem_color_098.png"),
		preload("res://Assets/Colored/genericItem_color_099.png"),
		preload("res://Assets/Colored/genericItem_color_100.png"),
		preload("res://Assets/Colored/genericItem_color_101.png"),
		preload("res://Assets/Colored/genericItem_color_102.png"),
		preload("res://Assets/Colored/genericItem_color_103.png"),
		preload("res://Assets/Colored/genericItem_color_104.png"),
		preload("res://Assets/Colored/genericItem_color_105.png"),
		preload("res://Assets/Colored/genericItem_color_106.png"),
		preload("res://Assets/Colored/genericItem_color_107.png"),
		preload("res://Assets/Colored/genericItem_color_108.png"),
		preload("res://Assets/Colored/genericItem_color_109.png"),
		preload("res://Assets/Colored/genericItem_color_110.png"),
		preload("res://Assets/Colored/genericItem_color_111.png"),
		preload("res://Assets/Colored/genericItem_color_112.png"),
		preload("res://Assets/Colored/genericItem_color_113.png"),
		preload("res://Assets/Colored/genericItem_color_114.png"),
		preload("res://Assets/Colored/genericItem_color_115.png"),
		preload("res://Assets/Colored/genericItem_color_116.png"),
		preload("res://Assets/Colored/genericItem_color_117.png"),
		preload("res://Assets/Colored/genericItem_color_118.png"),
		preload("res://Assets/Colored/genericItem_color_119.png"),
		preload("res://Assets/Colored/genericItem_color_120.png"),
		preload("res://Assets/Colored/genericItem_color_121.png"),
		preload("res://Assets/Colored/genericItem_color_122.png"),
		preload("res://Assets/Colored/genericItem_color_123.png"),
		preload("res://Assets/Colored/genericItem_color_124.png"),
		preload("res://Assets/Colored/genericItem_color_125.png"),
		preload("res://Assets/Colored/genericItem_color_126.png"),
		preload("res://Assets/Colored/genericItem_color_127.png"),
		preload("res://Assets/Colored/genericItem_color_128.png"),
		preload("res://Assets/Colored/genericItem_color_129.png"),
		preload("res://Assets/Colored/genericItem_color_130.png"),
		preload("res://Assets/Colored/genericItem_color_131.png"),
		preload("res://Assets/Colored/genericItem_color_132.png"),
		preload("res://Assets/Colored/genericItem_color_133.png"),
		preload("res://Assets/Colored/genericItem_color_134.png"),
		preload("res://Assets/Colored/genericItem_color_135.png"),
		preload("res://Assets/Colored/genericItem_color_136.png"),
		preload("res://Assets/Colored/genericItem_color_137.png"),
		preload("res://Assets/Colored/genericItem_color_138.png"),
		preload("res://Assets/Colored/genericItem_color_139.png"),
		preload("res://Assets/Colored/genericItem_color_140.png"),
		preload("res://Assets/Colored/genericItem_color_141.png"),
		preload("res://Assets/Colored/genericItem_color_142.png"),
		preload("res://Assets/Colored/genericItem_color_143.png"),
		preload("res://Assets/Colored/genericItem_color_144.png"),
		preload("res://Assets/Colored/genericItem_color_145.png"),
		preload("res://Assets/Colored/genericItem_color_146.png"),
		preload("res://Assets/Colored/genericItem_color_147.png"),
		preload("res://Assets/Colored/genericItem_color_148.png"),
		preload("res://Assets/Colored/genericItem_color_149.png"),
		preload("res://Assets/Colored/genericItem_color_150.png"),
		preload("res://Assets/Colored/genericItem_color_151.png"),
		preload("res://Assets/Colored/genericItem_color_152.png"),
		preload("res://Assets/Colored/genericItem_color_153.png"),
		preload("res://Assets/Colored/genericItem_color_154.png"),
		preload("res://Assets/Colored/genericItem_color_155.png"),
		preload("res://Assets/Colored/genericItem_color_156.png"),
		preload("res://Assets/Colored/genericItem_color_157.png"),
		preload("res://Assets/Colored/genericItem_color_158.png"),
		preload("res://Assets/Colored/genericItem_color_159.png"),
		preload("res://Assets/Colored/genericItem_color_160.png"),
		preload("res://Assets/Colored/genericItem_color_161.png"),
		preload("res://Assets/Colored/genericItem_color_162.png"),
		preload("res://Assets/Colored/genericItem_color_163.png"),
]

var bet = 0
var reels = [] # Lista bębnów
var spinning = false # Czy bębny kręcą się?
var reel_positions = [] # Pozycje bębnów
var btn5modulate

var texts: Array = ["What if I told you that genius isn't a gift, it's a
sentence.","What happens when illusions no longer protect you?","But ask yourself, what happens to a person who sees the truth too clearly?","He saw its loneliness, its
despair, its existential cost.","And what the genius perceives is not just beauty or truth but suffering.","Because happiness as we know it requires a certain blindness, a willingness to
play the game, to believe the illusion.","And yet, here's the paradox.","How do you live with a mind that sees too much?","How
do you carry a light that blinds even you?","How do you explain the architecture of
suffering to someone who's never seen it?","How do you articulate beauty so pure that it
hurts?"]

var info_texts: Array = ["You just won my heart!","Looks like you hit the jackpot, baby!","Well, well, aren't you the lucky one?","Guess who’s on fire? You are!", "Congrats, you’ve got the winning touch!", "I think you just unlocked a whole new level of awesome.","I knew you had it in you – and I like it!", "Hot stuff! You’re on a winning streak!", "You’ve got the magic, now let's see what else you can do!", "Is there anything you can’t win? Because I’m impressed!"]

var lose_info_texts: Array =["Looks like luck’s not on your side today, but you’re still a winner in my book!", "Well, you can’t win them all, but you still look pretty amazing!", "You didn’t win this time, but I’m still hooked on you!", "Don’t worry, even losers like you are charming!", "You didn’t hit the jackpot, but you definitely got my attention!", "Not this time, but don’t worry, I’ve got plenty of games to play!", "You may have lost the game, but you won my heart – again!", "You’re not a winner this time, but you’re definitely a heartbreaker!", "Well, you didn’t win, but at least you look good doing it!", "You may have lost the round, but you’ve still got me cheering for you!"]
# Funkcja inicjująca
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Label2.text = texts[randi_range(0,texts.size()-1)]
	original_position = camera.position
	# Inicjalizuj bębny
	#load_sprites_from_folder(folder_path) 
	btn5modulate = $btn5.modulate
	for j in range(row_reels):
		for i in range(num_reels):
			var reel = Sprite2D.new()
			reel.texture = sprites[randi_range(1,sprites.size()-1)] # Wybór losowego symbolu na start
			reel.scale = Vector2(.8,.8)
			reel.position = Vector2(100 * i, 100 * j) # Przesuń bębny na ekranie
			$Reels.add_child(reel)
			activate_smoke()
			reels.append(reel)
			reel_positions.append(0)  # Początkowa pozycja bębna
	

	# Przycisk uruchamiający grę
func _process(delta):
	if Input.is_action_just_pressed("add5") && !$btn5.disabled:
		_on_btn_5_pressed()
	if Input.is_action_just_pressed("bet1") && !$btn1.disabled:
		_on_btn_1_pressed()
	if Input.is_action_just_pressed("bet5") && !$btn5.disabled:
		_on_btn_5_pressed()
	if Input.is_action_just_pressed("bet2") && !$btn2.disabled:
		_on_btn_2_pressed()
	if Input.is_action_just_pressed("bet10") && !$btn10.disabled:
		_on_btn_10_pressed()
	if Input.is_action_just_pressed("bet25") && !$btn25.disabled:
		_on_btn_25_pressed()
	if Input.is_action_just_pressed("spin") && spin_button.disabled == false:
		_on_spin_pressed()
	if shake_timer > 0:
		shake_timer -= delta  # Decrease the shake timer
		# Apply random shake offset
		var shake_offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		camera.position = original_position + shake_offset  # Move the camera with the shake
	else:
		# Reset the camera to its original position after the shake is done
		camera.position = original_position

func start_shake():
	shake_timer = shake_duration  # Reset the shake timer
	
func _on_spin_pressed():
	$Label2.text = texts[randi_range(0,texts.size()-1)]
	$Sounds/Chain.play()
	spin_button.disabled = true
	$Button/SpinTimer.start()
	$Button/ResultTimer.start()
	if spinning:
		return
	spinning = true
	# Rozpocznij obrót bębnów
	
	for i in range(num_reels*row_reels):
		reel_positions[i] = 0
		var reel = reels[i]
		reel.texture = sprites[randi_range(1,sprites.size()-1)]
		#$Reels.add_child(reel)
		activate_smoke()
		# Uruchom animację obrotu
		start_reel_spin(i)

# Funkcja do rozpoczęcia obrotu bębna
func start_reel_spin(reel_index):
	start_shake()
	stop_reel_spin(reel_index)

# Funkcja do zatrzymania bębna
func stop_reel_spin(reel_index):
	var reel = reels[reel_index]
	
	reel.texture = sprites[randi_range(1,sprites.size())-1]  # Zmiana na losowy symbol po zatrzymaniu
	if reel_index == num_reels - 1:
		spinning = false
		#check_result()

# Funkcja do sprawdzenia wyniku
func scheck_result():
	var result = []
	for reel in reels:
		if reel.texture != null:
			# Jeśli tekstura jest przypisana, uzyskaj resource_path
			var texture_path = reel.texture.resource_path
			var texture_name = texture_path
			result.append(texture_name)
		else:
			# Jeśli brak tekstury, dodaj pusty wynik lub placeholder
			result.append("Brak tekstury")
	print("Wynik: " + str(result))

func _on_button_pressed() -> void:
	_on_spin_pressed()
	

func updateTicketBetValue(ticketsUsed):
	tickets = tickets - ticketsUsed
	bet = bet + ticketsUsed
	updateTicketBet()

func updateButtons():
	if(tickets>1):
		$btn1.disabled = false
	else:
		$btn1.disabled = true
		
	if(tickets>5):
		$btn5.disabled = false
	else:
		$btn5.disabled = true
		
	if(tickets - bet*2 > 0 && bet > 0):
		$btn2.disabled = false
	else:
		$btn2.disabled = true
		
	if(tickets - bet*10 > 0 && bet > 0):
		$btn10.disabled = false
	else:
		$btn10.disabled = true
		
	if(tickets - bet*25 > 0 && bet > 0):
		$btn25.disabled = false
	else:
		$btn25.disabled = true
	if bet > 0:
		$Button.disabled = false
	else:
		$Button.disabled = true

func updateTicketBet():
	start_shake()
	updateTickets()
	updateBet()
	updateLastWon()
	updateButtons()

func updateTickets():
	$AvailablePanel/AvailableTickets.text = str(tickets)
	
func updateBet():
	$BetPanel/Bet.text = str(bet)

func updateLastWon():
	$LastWon/LastWon2.text = str(last_won)

func _on_btn_1_pressed() -> void:
	updateTicketBetValue(1) # Replace with function body.
	$btn1.modulate = Color(1, 0, 0, 0.5)
	$btn1/btn1timer.start()

func _on_btn_5_pressed() -> void:
	updateTicketBetValue(5)
	$btn5.modulate = Color(1, 0, 0, 0.5)
	$btn5/btn5timer.start()

func _on_btn_5_timer_timeout() -> void:
	$btn5.modulate = btn5modulate

func _on_btn_2_pressed() -> void:
	updateTicketBetValue(bet*2)
	$btn2.modulate = Color(1, 0, 0, 0.5)
	$btn2/btn2timer.start()

func _on_btn_10_pressed() -> void:
	updateTicketBetValue(bet*10)
	$btn10.modulate = Color(1, 0, 0, 0.5)
	$btn10/btn10timer.start()


func _on_btn_25_pressed() -> void:
	updateTicketBetValue(bet*25)
	$btn25.modulate = Color(1, 0, 0, 0.5)
	$btn25/btn25timer.start()


func _on_result_timer_timeout() -> void:
	var win = false
	var random_win_value = randi_range(1,5)
	if random_win_value > 3:
		win = true
	if tickets < 100:
		win = true
	if(win):
		last_won = bet* randi_range(2,3)
		play_win_sounds()
		$Control/Info.text = info_texts[randi_range(1, info_texts.size()-1)]
		$Control/Info.add_theme_color_override("font_color",Color(255,215,0))
		tickets = tickets + last_won
		$AvailablePanel/GPUParticles2D.emitting= true
		$LastWon/GPUParticles2D.emitting= true
	else:
		play_lose_sounds()
		$Control/Info.text = lose_info_texts[randi_range(1, lose_info_texts.size()-1)]
		$Control/Info.add_theme_color_override("font_color",Color(255,0,0))
		last_won = 0
		
	bet = 0
	start_info_anim()
	$Button.disabled = true
	updateTicketBet()
	if(tickets>999):
		$Reels.visible = false
		$VideoStreamPlayer.visible = true
		$VideoStreamPlayer.play()
		$LastOrderTimer.start()

func play_win_sounds():
	$Sounds/AudioStreamPlayer2D.play()
	$Sounds/AudioStreamPlayer2D.pitch_scale = (randf_range(.5,2))
	$Sounds/AudioStreamPlayer2D2.play()
	$Sounds/AudioStreamPlayer2D2.pitch_scale = (randf_range(.5,2))
	$Sounds/AudioStreamPlayer2D3.play()
	$Sounds/AudioStreamPlayer2D3.pitch_scale = (randf_range(.5,2))
	$Sounds/AudioStreamPlayer2D4.play()
	$Sounds/AudioStreamPlayer2D4.pitch_scale = (randf_range(.5,2))

func play_lose_sounds():
	$Sounds/Haha.play()
	$Sounds/Haha.pitch_scale = (randf_range(.5,.8))
	$Sounds/Haha2.play()
	$Sounds/Haha2.pitch_scale = (randf_range(.5,.8))
	$Sounds/Haha3.play()
	$Sounds/Haha3.pitch_scale = (randf_range(.5,.8))
	$Sounds/Haha4.play()
	$Sounds/Haha4.pitch_scale = (randf_range(.5,.8))

func execute_last_order():
	var explosion = last_particle.instantiate()
	get_tree().current_scene.add_child(explosion)
	var explosion1 = last_particle.instantiate()
	get_tree().current_scene.add_child(explosion1)
	var explosion2 = last_particle.instantiate()
	get_tree().current_scene.add_child(explosion2)
	var explosion3 = last_particle.instantiate()
	get_tree().current_scene.add_child(explosion3)
	var explosion4 = last_particle.instantiate()
	get_tree().current_scene.add_child(explosion4)
	var explosion5 = last_particle.instantiate()
	get_tree().current_scene.add_child(explosion5)
	var explosion6 = last_particle.instantiate()
	get_tree().current_scene.add_child(explosion6)


func _on_last_order_timer_timeout() -> void:
	execute_last_order()
	
func start_info_anim():
	$AnimationPlayer.play("PlayAnim")
	$AnimationPlayer/AnimCont.start()

func _on_anim_cont_timeout() -> void:
	$AnimationPlayer.play("PlayIdle")

func activate_smoke():
	$SmokeRoll.emitting = true
	$SmokeRoll2.emitting = true
	$SmokeRoll3.emitting = true
	$SmokeRoll4.emitting = true
	$SmokeRoll5.emitting = true
	$SmokeRoll6.emitting = true
	$SmokeRoll7.emitting = true
	$SmokeRoll8.emitting = true
	$SmokeRoll9.emitting = true
	$SmokeRoll10.emitting = true
	$SmokeRoll11.emitting = true
	$SmokeRoll12.emitting = true
	$SmokeRoll13.emitting = true
	$SmokeRoll14.emitting = true
	$SmokeRoll15.emitting = true
	$SmokeRoll16.emitting = true
	$SmokeRoll17.emitting = true
	$SmokeRoll18.emitting = true
	$SmokeRoll19.emitting = true
	$SmokeRoll20.emitting = true
	$SmokeRoll21.emitting = true
	$SmokeRoll22.emitting = true
	$SmokeRoll23.emitting = true
	$SmokeRoll24.emitting = true
	$SmokeRoll25.emitting = true
	$SmokeRoll26.emitting = true
	$SmokeRoll27.emitting = true
	$SmokeRoll28.emitting = true
	$SmokeRoll29.emitting = true
	$SmokeRoll30.emitting = true
	$SmokeRoll31.emitting = true
	$SmokeRoll32.emitting = true
	$SmokeRoll33.emitting = true
	$SmokeRoll34.emitting = true
	$SmokeRoll35.emitting = true
	$SmokeRoll36.emitting = true
	$SmokeRoll37.emitting = true
	$SmokeRoll38.emitting = true
	$SmokeRoll39.emitting = true
	$SmokeRoll40.emitting = true
	$SmokeRoll41.emitting = true
	$SmokeRoll42.emitting = true


func _on_btn_1_timer_timeout() -> void:
	$btn1.modulate = btn5modulate


func _on_btn_2_timer_timeout() -> void:
	$btn2.modulate = btn5modulate


func _on_btn_10_timer_timeout() -> void:
	$btn10.modulate = btn5modulate


func _on_btn_25_timer_timeout() -> void:
	$btn25.modulate = btn5modulate
