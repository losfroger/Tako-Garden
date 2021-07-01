# Class that lets you assign probabilities to the items, and lets you get a random item based on that
class_name WeightedRandom

var _total_weight = 0
var _prob_table: Array

func _init(_items: Array) -> void:
	for item in _items :
		item = item as Dictionary
		assert(item.has_all(["item", "weight"]), "Error items")
		add_entry(item.item, item.weight)
	calc_probability()

func add_entry(item, weight: float) -> void:
	_total_weight += weight
	_prob_table.append({"item": item, "weight": weight, "accumulated": _total_weight, "probability": 0.0})


func calc_probability():
	for item in _prob_table:
		item.probability = item.weight / _total_weight


# This method returns an item from the list, taking into account the probability of each one
func random_pick():
	var roll: float = rand_range(0.0, _total_weight)
	for item in _prob_table:
		if item.accumulated > roll:
			return item.item
	return null
