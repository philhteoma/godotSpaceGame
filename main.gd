extends Node2D

const shipScene = preload("res://Scenes/ship.tscn")
const laserScene = preload("res://Scenes/laser.tscn")
const Enemy1Scene = preload("res://Scenes/Enemy1.tscn")
const deadEnemyScene = preload("res://Scenes/deadEnemy.tscn")
const heartScene = preload("res://Scenes/heart.tscn")


var rng = RandomNumberGenerator.new()

var ship = null
var shipSpeed = 50
var backgroundScrollSpeed = 50
var firingDelay = 0.5

var currentXPosition = 0

var fireCooldown = 0
var inFireCooldown = false

var enemies = []
var enemyYStartMin = 30
var enemyYStartMax = 120
var baseEnemySpawnDelay = float(2)
var enemySpawnDelay = baseEnemySpawnDelay
var enemySpawnCooldown = float(0)

var maxHealth = 3
var currentHealth = maxHealth
var hearts = []
var healthBarLocation = Vector2(20, 130)
var heartSpacing = 20

var difficulty = float(100)
var score = 0
var gameInProgress = false

func fire_laser():
  self.inFireCooldown = true
  var laser = laserScene.instance()
  laser.position = self.ship.position + Vector2(20, 0)
  add_child(laser)


func laser_hit(laser, enemy):
  self.score += 1
  laser.queue_free()
  var enemyPosition = enemy.position
  enemy.queue_free()
  var remains = deadEnemyScene.instance()
  remains.position = enemyPosition
  add_child(remains)


func spawn_enemy():
  var yStart = rng.randf_range(self.enemyYStartMin, self.enemyYStartMax)
  var enemy = Enemy1Scene.instance()
  enemy.position = Vector2(self.currentXPosition + 250, yStart)
  enemy.oscMagnitude = rng.randf_range(10, 30)
  enemy.oscSpeed = rng.randf_range(1, 6)
  enemy.speed = rng.randf_range(-100, -30)
  enemy.yStart = yStart
  self.enemies.append(weakref(enemy))
  var _err = enemy.connect("reached_end", self, "take_hit")
  self.add_child(enemy)


func spawn_ship():
  self.ship = shipScene.instance()
  ship.position = Vector2(self.currentXPosition + 40, 75)
  self.add_child(self.ship)


func set_up_health():
  for h in self.hearts:
    if h.get_ref():
      h.get_ref().queue_free()
  self.hearts = []
  self.currentHealth = self.maxHealth
  var currentHeartLocation = self.healthBarLocation + Vector2(self.currentXPosition, 0)
  for i in range(self.maxHealth):
    var heart = heartScene.instance()
    heart.position = currentHeartLocation
    currentHeartLocation += Vector2(self.heartSpacing, 0)
    self.hearts.append(weakref(heart))
    add_child(heart)


func take_hit(enemy):
  self.currentHealth -= 1
  self.hearts[self.currentHealth].get_ref().empty_heart()
  enemy.queue_free()
  
  if self.currentHealth <= 0:
    self.game_over()


func game_over():
  for e in self.enemies:
    if e.get_ref():
      e.get_ref().queue_free()
  self.enemies = []
  self.ship.queue_free()
  $RetryButton.visible = true
  $RetryButton.disabled = false
  $RetryButton.rect_position.x = self.currentXPosition + 70
  self.gameInProgress = false

  

func _ready():
  for a in InputMap.get_actions():
    print(a)
    for x in InputMap.get_action_list(a):
      print("  " + x.as_text())
    print()
  rng.randomize()
  OS.set_window_size(Vector2(800, 600))
  $RetryButton.visible = false
  
  
  
func _process(delta):
  if self.gameInProgress:
    self.currentXPosition += backgroundScrollSpeed*delta
    
    $Camera2D.position += Vector2(backgroundScrollSpeed*delta, 0)
    ship.position += Vector2(backgroundScrollSpeed*delta, 0)
      
    if Input.is_key_pressed(KEY_SPACE) and not self.inFireCooldown:
      self.fire_laser()
      self.fireCooldown = 0
    else:
      self.fireCooldown += delta
      if self.fireCooldown >= self.firingDelay:
        self.fireCooldown = 0
        self.inFireCooldown = false
    
    self.enemySpawnCooldown += delta
    if self.enemySpawnCooldown > self.enemySpawnDelay:
      self.enemySpawnCooldown = 0
      self.spawn_enemy()
  
    for heart in hearts:
      heart.get_ref().position += Vector2(backgroundScrollSpeed*delta, 0)
    
    self.enemySpawnDelay -= self.difficulty / 1000000
    
    $Camera2D/Score.text = "SCORE: " + str(self.score)
    # $Score.rect_position.x += self.backgroundScrollSpeed * delta
    
    # print($Score.rect_position.x, " : ", self.hearts[0].get_ref().position)


func _on_BeginButton_pressed():
  $BeginButton.visible = false
  self.gameInProgress = true
  self.enemySpawnDelay = self.baseEnemySpawnDelay
  self.score = 0
  self.spawn_ship()
  self.set_up_health()


func _on_RetryButton_pressed():
  $RetryButton.visible = false
  self.gameInProgress = true
  self.enemySpawnDelay = self.baseEnemySpawnDelay
  self.score = 0
  self.spawn_ship()
  self.set_up_health()
