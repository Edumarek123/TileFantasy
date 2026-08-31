extends Resource
class_name BaseStats

#----------------#BASE STATS#----------------#
@export var strength : int = 1 : get = strength_get, set = strength_set
@export var dexterity : int = 1 : get = dexterity_get, set = dexterity_set
@export var intellect : int = 1 : get = intellect_get, set = intellect_set
@export var vitality : int = 1 : get = vitality_get, set = vitality_set
@export var soul : int = 1 : get = soul_get, set = soul_set

#----------------#DERIVED STATS#----------------#
@export var health : int = 1 : get = health_get
@export var mana : int = 1 : get = mana_get
@export var power : int = 1 : get = power_get
@export var defense_physic : int = 1 : get = defense_physic_get
@export var defense_magic : int = 1 : get = defense_magic_get
@export var precision : int = 1 : get = precision_get
@export var critical_chance : int = 1 : get = critical_chance_get
@export var bonus_attack_chance : int = 1 : get = bonus_attack_chance_get
@export var enchant_multiplier : int = 1 : get = enchant_multiplier_get
@export var skill_mastery : int = 1 : get = skill_mastery_get

#----------------#AUX STATS#----------------#
@export var focus : int = 1 : get = focus_get, set = focus_set
@export var weapon_type : int = 0 : get = weapon_type_get, set = weapon_type_set

#----------------#SETTERS#----------------#
func strength_set(value : int) -> void:
	strength = maxi(1, value)

func dexterity_set(value : int) -> void:
	dexterity = maxi(1, value)

func intellect_set(value : int) -> void:
	intellect = maxi(1, value)

func vitality_set(value : int) -> void:
	vitality = maxi(1, value)

func soul_set(value : int) -> void:
	soul = maxi(1, value)

#----------------#GETTERS (BASE)#----------------#
func strength_get() -> int:
	return strength

func dexterity_get() -> int:
	return dexterity

func intellect_get() -> int:
	return intellect

func vitality_get() -> int:
	return vitality

func soul_get() -> int:
	return soul

#----------------#GETTERS (DERIVED)#----------------#
func health_get() -> int:
	return vitality * BaseModifiersRules.stats_modifiers["health"]

func mana_get() -> int:
	return dexterity * BaseModifiersRules.stats_modifiers["mana"]

func power_get() -> int:
	match weapon_type:
		1:
			return strength * BaseModifiersRules.stats_modifiers["power_strenght"]
		2:
			return intellect * BaseModifiersRules.stats_modifiers["power_magic"]
		3:
			return dexterity * BaseModifiersRules.stats_modifiers["power_dexterity"]
		4: 
			return soul * BaseModifiersRules.stats_modifiers["power_soul"]
		_:
			return 1

func defense_physic_get() -> int:
	return vitality * BaseModifiersRules.stats_modifiers["defense_physic"]

func defense_magic_get() -> int:
	return intellect * BaseModifiersRules.stats_modifiers["defense_magic"]

func precision_get() -> int:
	return dexterity * BaseModifiersRules.stats_modifiers["precision"]

func critical_chance_get() -> int:
	return dexterity * BaseModifiersRules.stats_modifiers["critical_chance"]

func bonus_attack_chance_get() -> int:
	return dexterity * BaseModifiersRules.stats_modifiers["bonus_attack_chance"]

func enchant_multiplier_get() -> int:
	return soul * BaseModifiersRules.stats_modifiers["enchant_multiplier"]

func skill_mastery_get() -> int:
	return intellect * BaseModifiersRules.stats_modifiers["skill_mastery"]

#----------------#GETTERS (AUX)#----------------#
func focus_get() -> int:
	return focus * BaseModifiersRules.stats_modifiers["focus"]

func weapon_type_get() -> int:
	return weapon_type
	
#----------------#SETTERS (AUX)#----------------#
func focus_set(value : int) -> void:
	focus = maxi(0, value)

func weapon_type_set(value : int) -> void:
	weapon_type = value
	
func print_stats() -> void:
	print("//--------- BASE STATS ---------//")
	print("strength: ", strength)
	print("dexterity: ", dexterity)
	print("intellect: ", intellect)
	print("vitality: ", vitality)
	print("soul: ", soul)

	print("//--------- DERIVED STATS ---------//")
	print("health: ", health)
	print("mana: ", mana)
	print("power: ", power)
	print("defense_physic: ", defense_physic)
	print("defense_magic: ", defense_magic)
	print("precision: ", precision)
	print("critical_chance: ", critical_chance)
	print("bonus_attack_chance: ", bonus_attack_chance)
	print("enchant_multiplier: ", enchant_multiplier)
	print("skill_mastery: ", skill_mastery)

	print("//--------- AUX STATS ---------//")
	print("focus: ", focus)
	print("weapon_type: ", weapon_type)
