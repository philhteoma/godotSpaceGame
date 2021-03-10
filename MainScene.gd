extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jumping = false
var canJump = true
var jumpDelayTimer = 0
var jumpForce = Vector2(0, -3000)


# Called when the node enters the scene tree for the first time.
func _ready():
  # $Player.position = Vector2(30, 80)
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  $Player/PlayerPhysics.applied_force = Vector2(0,0)
  print("Rigid Location: ", $Player/PlayerPhysics.position, ".  KinematicLocation: ", $Player/PlayerPhysics/PlayerKinematic.position)
  
  # print($Player/PlayerPhysics/PlayerKinematic.is_on_floor())
  if not self.canJump:
    self.jumpDelayTimer += delta
    if jumpDelayTimer > 0.5: self.canJump = true
  
  if Input.is_key_pressed(KEY_SPACE):
    if self.canJump and $Player/PlayerPhysics/PlayerKinematic.is_on_floor():
      self.jumping = true
      self.jumpDelayTimer = 0
      print("Jumping")
      $Player/PlayerPhysics.applied_force = jumpForce
