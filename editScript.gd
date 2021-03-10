tool
extends EditorScript

var enemyTexture = preload("res://Resources/Sprites/Enemy1..png")

var superEnemies = [
  "SuperEnemy1",
  "SuperEnemy2",
  "SuperEnemy3",
]


func _run():
  print("This script is running!")
  
  var xPosition = 50
  for enemy in superEnemies:
    var node = Sprite.new()
    node.texture = enemyTexture
    
    node.set_name(enemy)
    
    self.get_scene().add_child(node)
    node.set_owner(self.get_scene())
    
    node.position = Vector2(xPosition, 75)
    xPosition += 50
    #


#func _process(delta):
#  pass
