extends ComboPiece

func passive() -> float:
	return PlayerStats.player_stats["attack"] * modifier
