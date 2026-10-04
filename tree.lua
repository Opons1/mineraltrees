
--function for registering mineral trees--
function mineraltrees.register_mineral_tree(mineral, has_bloom, tree_rarity_mult, enabled)
	if not enabled then
		return
	end

	local upper_mineral = string.gsub(mineral, "^%l", string.upper)
	local tree_name = "mineraltrees:"..mineral.."tree"
	local sapling_name = "mineraltrees:"..mineral.."sapling"
	--registers the log of the respective tree--
	minetest.register_node(tree_name, {
		description = upper_mineral.."wood Tree",
		tiles = {"default_tree_top.png", "default_tree_top.png", "mineraltrees_"..mineral.."tree.png"},
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
		on_place = minetest.rotate_node,
		sounds = default.node_sound_wood_defaults()
	})
	
	--registers the leaves of the respective tree--
	minetest.register_node("mineraltrees:"..mineral.."leaves", {
		description = upper_mineral.."wood Leaves",
		drawtype = "allfaces_optional",
		visual_scale = 1.3,
		tiles ={"mineraltrees_"..mineral.."leaves.png"},
		paramtype = "light",
		is_ground_content = false,
		groups = {snappy=3, leafdecay=7, flammable=1},
		drop = {
			max_items = 1,
			items = {
				{
					-- player will get sapling with 1/200 chance
					items = {"mineraltrees:"..mineral.."sapling"},
					rarity = 200,
				},
				{
					-- player will get leaves only if he get no saplings,
					-- this is because max_items is 1
					items = {"mineraltrees:"..mineral.."leaves"},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
	})

	--registers the sapling of the respective tree
	minetest.register_node(sapling_name, {
		description = upper_mineral.."wood Sapling",
		drawtype = "plantlike",
		visual_scale = 1.0,
		tiles ={"mineraltrees_"..mineral.."sapling.png"},
		inventory_image = "mineraltrees_"..mineral.."sapling.png",
		wield_image = "mineraltrees_"..mineral.."sapling.png",
		paramtype = "light",
		walkable = false,
		is_ground_content = true,
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
		},
		sounds = default.node_sound_leaves_defaults(),
		groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},

		on_construct = function(pos)
			core.get_node_timer(pos):start(math.random(1, 2))
		end,

		on_timer = default.grow_sapling,

		on_place = function(itemstack, placer, pointed_thing)
			itemstack = default.sapling_on_place(itemstack, placer, pointed_thing, sapling_name, {x = 8, y = 1, z = 8}, {x = -8, y = 16, z = -8}, 4)
			return itemstack
		end,
	})
	
	local tree_def = {
		axiom ="FFFFFFFAFFFFF/A",
		rules_a = "[&&[F^TFDFFDFFDFF][--F^TFDFFDFFDFF][----F^TFDFFDFFDFF][++F^TFDFFDFFDFF]]",
		rules_b = "",
		rules_c = "F",
		rules_d = "&",
		trunk="mineraltrees:"..mineral.."tree",
		leaves="mineraltrees:"..mineral.."leaves",
		angle=mineraltrees.tree_angle,
		iterations=2,
		random_level=0,
		trunk_type="crossed",
		thin_branches=true,
		fruit_chance=0,
		fruit="default:apple"
	}
	
	local function grow_tree(pos)
		minetest.remove_node(pos)
		minetest.spawn_tree(pos, tree_def)
	end
	
	--registers plant growing
	--[[
	plantslib:grow_plants({
		grow_delay = 10,
		grow_chance = 1,
		grow_plant = "mineraltrees:"..mineral.."sapling",
		grow_nodes = "default:dirt_with_grass",
		grow_function = tree_def
	})
	]]
	default.register_sapling_growth(sapling_name, {
		can_grow = default.can_grow,
		on_grow_failed = default.on_grow_failed,
		grow = grow_tree
	})
	--registers bark
	minetest.register_craftitem("mineraltrees:"..mineral.."bark", {
		description = upper_mineral.."wood Bark",
		inventory_image = "mineraltrees_"..mineral.."tree.png",
		weild_image = "mineraltrees_"..mineral.."tree.png",
		weild_scale = 1,
		stack_max = 99,
		liquids_pointable = false
	})
	
	--registers bloom if applicable
	if has_bloom then
		minetest.register_craftitem("mineraltrees:"..mineral.."_bloom", {
			description = upper_mineral.." Bloom",
			inventory_image = "mineraltrees_"..mineral.."_bloom.png",
			weild_image = "mineraltrees_"..mineral.."bloom.png",
			weild_scale = 1,
			stack_max = 99,
			liguids_pointable = false
		})
		
		minetest.register_craft({
			type = "cooking",
			output = "mineraltrees:"..mineral.."_bloom",
			recipe = "mineraltrees:"..mineral.."bark"
		})
	else
		minetest.register_craft({
		type = "fuel",
		recipe = "mineraltrees:"..mineral.."bark",
		burntime = 5
	})
	end
	
	table.insert(mineraltrees.bark_array, "mineraltrees:"..mineral.."bark 4")
	table.insert(mineraltrees.bloom_array, "mineraltrees:"..mineral.."_bloom")
	table.insert(mineraltrees.tree_array, "mineraltrees:"..mineral.."tree")

	--add decoration
	core.register_decoration({
		deco_type = "lsystem",
		place_on = "group:soil",
		sidelen = 8,
		fill_ratio = 0.001 / mineraltrees.base_rarity * tree_rarity_mult,
		y_min = mineraltrees.min_elevation,
		y_max = mineraltrees.max_elevation,
		treedef = tree_def
	})
end