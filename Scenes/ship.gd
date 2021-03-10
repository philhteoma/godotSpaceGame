extends Node2D

var shipDefaultPng = load("res://Resources/Sprites/ship.png")
# var shipTiltPng = load("res://Sprites/shipTiltUp.png")
var shipTiltPng = load("res://Resources/Sprites/shipTiltUp.png")

var parentScene = null

var count = 0


func _ready():
  self.parentScene = get_node("..")


func _process(delta):
  var shipState = null
  
  if Input.is_key_pressed(KEY_RIGHT):
    self.position += Vector2(get_node("..").shipSpeed * delta, 0)
  if Input.is_key_pressed(KEY_LEFT):
    self.position += Vector2(get_node("..").shipSpeed * delta * -1, 0)
  if Input.is_key_pressed(KEY_UP):
    self.position += Vector2(0, get_node("..").shipSpeed * delta * -1)
    shipState = "UP"
  if Input.is_key_pressed(KEY_DOWN):
    self.position += Vector2(0, get_node("..").shipSpeed * delta)
    shipState = "DOWN"
  
  
  if shipState == "UP":
    $Sprite.texture = shipTiltPng
    $Sprite.set_flip_v(false)
  elif shipState == "DOWN":
    $Sprite.texture = shipTiltPng
    $Sprite.set_flip_v(true)
  else:
    $Sprite.texture = shipDefaultPng
  
