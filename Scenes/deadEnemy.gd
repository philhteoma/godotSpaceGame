extends Node2D

var parentScene = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  self.parentScene = get_node("..")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if self.position.x < -20 + self.parentScene.currentXPosition:
    self.queue_free()
