extends Node2D

signal reached_end(enemy)

var timePassed = float(0)
var oscMagnitude = 20
var oscSpeed = 3

var yStart = null
var parentScene = null
var speed = -80

func _get_next_y_position(time):
  # print(self.yStart + sin(timePassed)*self.oscMagnitude)
  return self.yStart + sin(time*oscSpeed)*self.oscMagnitude


func _ready():
  self.parentScene = get_node("..")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  self.timePassed += delta
  self.position.x += (self.parentScene.backgroundScrollSpeed + self.speed) * delta
  self.position.y = self._get_next_y_position(self.timePassed)
  
  if self.position.x < -20 + self.parentScene.currentXPosition:
    emit_signal("reached_end", self)    
  
