extends Node

var physical_entities: Array[PhysicalEntity]

func on_physicalized(pe: PhysicalEntity):
	print("phys " + pe.name)
	physical_entities.append(pe)
	
func on_dephysicalized(pe: PhysicalEntity):
	for i in range(len(physical_entities)):
		if physical_entities[i] == pe:
			physical_entities.remove_at(i)
			break
			
