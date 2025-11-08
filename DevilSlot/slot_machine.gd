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

@export var roll_particle: PackedScene
@export var last_particle: PackedScene

var sprites : Array = []

# Ścieżka do folderu ze sprite'ami
var folder_path : String = "res://Assets/Colored/"

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
	$Label2.text = texts[randi_range(0,texts.size()-1)]
	original_position = camera.position
	# Inicjalizuj bębny
	load_sprites_from_folder(folder_path) 
	btn5modulate = $btn5.modulate
	for j in range(row_reels):
		for i in range(num_reels):
			var reel = Sprite2D.new()
			reel.texture = sprites[randi_range(1,sprites.size()-1)] # Wybór losowego symbolu na start
			reel.scale = Vector2(.8,.8)
			reel.position = Vector2(100 * i, 100 * j) # Przesuń bębny na ekranie
			
			add_child(reel)
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
		var explosion = roll_particle.instantiate()
		explosion.global_position = reel.position
		get_tree().current_scene.add_child(explosion)
		# Uruchom animację obrotu
		start_reel_spin(i)

# Funkcja do rozpoczęcia obrotu bębna
func start_reel_spin(reel_index):
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

func load_sprites_from_folder(path: String):
	var dir = DirAccess.open(path)  # Używamy DirAccess do otwarcia folderu
	if dir:
		dir.list_dir_begin()  # Zaczynamy przeglądanie folderu
		var file_name = dir.get_next()
		while file_name != "":
			# Sprawdzamy, czy to jest plik z obrazkiem (np. .png)
			if file_name.ends_with(".png"):  # Możesz dostosować rozszerzenie
				var texture = load(path + file_name)  # Ładujemy teksturę
				sprites.append(texture)  # Dodajemy do tablicy
			file_name = dir.get_next()  # Przechodzimy do następnego pliku
		dir.list_dir_end()  # Kończymy przeglądanie folderu

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

func _on_btn_5_pressed() -> void:
	updateTicketBetValue(5)
	$btn5.modulate = Color(1, 0, 0, 0.5)
	$btn5/btn5timer.start()

func _on_btn_5_timer_timeout() -> void:
	$btn5.modulate = btn5modulate

func _on_btn_2_pressed() -> void:
	updateTicketBetValue(bet*2)

func _on_btn_10_pressed() -> void:
	updateTicketBetValue(bet*10)


func _on_btn_25_pressed() -> void:
	updateTicketBetValue(bet*25)


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
