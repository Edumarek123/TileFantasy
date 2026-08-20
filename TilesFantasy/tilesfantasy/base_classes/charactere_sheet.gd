extends Resource
class_name CharactereSheet

#----------------#GENERAL INFORMATION#----------------#
@export var name : String = ""
@export var nation : String = ""
@export var level : int = 1
@export var title : String = ""
@export var character_creation_date : String = ""
@export var death_date : String = ""

#----------------#PROGRESSION & RESOURCES#----------------#
@export var soul_crystals_collected : int = 0
@export var soul_crystals : int = 0
@export var hours_played : int = 0
@export var items_crafted : int = 0
@export var quests_created : int = 0
@export var quests_completed : int = 0

#----------------#COMBAT STATS#----------------#
@export var creatures_killed : int = 0
@export var bosses_defeated : int = 0
@export var players_killed : int = 0
@export var duels_won : int = 0

#----------------#DATA STRUCTURES#----------------#
@export var inventory : Dictionary = {}
@export var grimoire : Dictionary = {}
@export var profession : Dictionary = {}

#----------------#BASE STATS#----------------#
@export var base_stats : BaseStats





#
