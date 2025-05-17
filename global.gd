extends Node
#these are here to avoid the referencing issues
signal player_detonated
signal delayed_player_detonated
#used to determine which level-switching buttons to enable - rest in level.gd
var highest_level_completed:int = 0
