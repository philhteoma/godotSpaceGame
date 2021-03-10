extends Node2D

var speed = 60
var parentScene = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
  self.parentScene = get_node("..")



func _process(delta):
  self.position += Vector2((self.parentScene.backgroundScrollSpeed+speed)*delta, 0)
  
  # var overlaps = $Area2D.get_overlapping_areas()
  # if len(overlaps) > 0:
  #   print(overlaps[0].get_parent().name)
    # if overlaps[0].get_parent().name in ["Enemy"] :
    #   # print("Collision")
    #   self.parentScene.laser_hit(self, overlaps[0].get_parent())
  
  if self.position.x > 220 + self.parentScene.currentXPosition:
    self.queue_free()


func _on_Area2D_area_shape_entered(_area_id, area, _area_shape, _self_shape):
  self.parentScene.laser_hit(self, area.get_parent())
