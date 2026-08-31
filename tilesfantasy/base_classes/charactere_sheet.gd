extends Resource
class_name CharactereSheet

#----------------#GENERAL INFORMATION#----------------#
@export var player_id : String = ""
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
@export var inbox : Dictionary = {}

#----------------#BASE STATS#----------------#
@export var base_stats : BaseStats

func load_charactere(data: Dictionary) -> void:
	if not base_stats:
		base_stats = BaseStats.new()
	
	for key in data:
		if key == "base_stats":
			for bey in data["base_stats"]:
				if bey in base_stats:
					base_stats.set(bey, data["base_stats"][bey]) 
		elif key in self:
			set(key, data[key])


func print_sheet() -> void:
	print("//--------- CHARACTER SHEET ---------//")

	print("//--------- GENERAL INFORMATION ---------//")
	print("player_id: ", player_id)
	print("name: ", name)
	print("nation: ", nation)
	print("level: ", level)
	print("title: ", title)
	print("character_creation_date: ", character_creation_date)
	print("death_date: ", death_date)

	print("//--------- PROGRESSION & RESOURCES ---------//")
	print("soul_crystals_collected: ", soul_crystals_collected)
	print("soul_crystals: ", soul_crystals)
	print("hours_played: ", hours_played)
	print("items_crafted: ", items_crafted)
	print("quests_created: ", quests_created)
	print("quests_completed: ", quests_completed)

	print("//--------- COMBAT STATS ---------//")
	print("creatures_killed: ", creatures_killed)
	print("bosses_defeated: ", bosses_defeated)
	print("players_killed: ", players_killed)
	print("duels_won: ", duels_won)

	print("//--------- DATA STRUCTURES ---------//")
	print("inventory: ", inventory)
	print("grimoire: ", grimoire)
	print("profession: ", profession)
	print("inbox: ", inbox)

	#//--------- BASE STATS ---------//"
	if base_stats:
		base_stats.print_stats()
	else:
		print("base_stats: null")

	print("//--------- END CHARACTER SHEET ---------//")
