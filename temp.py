extends Node2D

const baseRoomScene = preload("res://Scenes/Room.tscn")

var boxPixelSize = 20

var rooms = {}

# Location should specify top-left corner of room
func create_room(location, length, depth, name):
  self.rooms[name] = baseRoomScene.instance(location, boxPixelSize, length, depth)


func find_shortest_path(character, endRoom):
  var startNode = get_charcter_location(character)
  var endNode = find_available_space(endRoom)
  if not endNode:
    return false
  path = recursively_find_path(startNode, endNode, [startNode], false)


func recursively_find_path(currentNode, endNode, visitedNodes, changeRoom):
  if currentNode == endNode:
    return [endNode]

  # Get valid nodes to move to
  if not changeRoom:
    var connectingNodes = currentNode.getRoom.getRoomNodes()
    connectingNodes.remove(currentNode)
  else:
    var connectingNodes = currentNode.get_room_transfer_nodes()

  for node in connectingNodes:
    if node in visitedNodes:
      connectingNodes.remove(currentNode)
  if len(connectingNodes) == 0:
    return False

  for node in connectingNodes:
    visitedNodes.append(node)

  # Recursively check path lengths
  var potential_paths = []
  for node in connectingNodes:
    var path = recursively_find_path(node, endNode, visitedNodes, not changeRoom)
    if path:
      potential_paths.append(path)

  # No valid paths from here
  if len(potential_paths) = 0:
    return False

  # Calculate shortest path
  var pathLengths = []
  for path in potential_paths:
    path.append(currentNode)
    pathlengths.append(calculate_path_length(path))

  var shortestPath = potential_paths[pathLengths.index(min(pathLengths))]
  return shortestPath


func _ready():
  create_room(Vector2(0,0), 3, 3, "TestRoom")


#func _process(delta):
#  pass
