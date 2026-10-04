--config options
mineraltrees.tree_angle = 45 --how 'bent' the limbs and branches of all mineraltrees are. Warning: changes may be unpredictable
mineraltrees.seed_dif = 675 --The difference between the world's seed and the mineraltree's seed. Good for maintaining compatibility IMPORTANT: changes as trees are registered
mineraltrees.base_rarity = 95--How rare, out of 100, a mineraltree is. Calculated using this < math.random(1, 100)

--tree-specific rareness options
--number is a weight multiplier
mineraltrees.coal_rarity = 3
mineraltrees.iron_rarity = 1
mineraltrees.copper_rarity = 1
mineraltrees.gold_rarity = 0.5
mineraltrees.mese_rarity = 0.3
mineraltrees.diamond_rarity = 0.2

--tree-specific enabling
mineraltrees.enable_coal_tree = true
mineraltrees.enable_iron_tree = true
mineraltrees.enable_copper_tree = true
mineraltrees.enable_gold_tree = true
mineraltrees.enable_mese_tree = true
mineraltrees.enable_diamond_tree = true

--biome config options. Dictate in how many circumstances a mineraltree can spawn. More specific values make for rarer trees.
mineraltrees.min_elevation = 0
mineraltrees.max_elevation = 60

