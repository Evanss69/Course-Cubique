--initialisation de la méta donnée à l'apparition du joueur
minetest.register_on_joinplayer(function(player)
	minetest.get_meta(player)
	player:set_attribut('blockstart', true)
	end)

--suppression de la métadonnée lorsqu'on quitte minetest
minetest.register_on_leaveplayer(function(player)
	minetest.get_meta(player):set_string('blockstart', nil)
	end)

--création d'un nouveau bloc de départ
minetest.register_mode('new_mod:start_cube',{
	description={'bloc départ'},
	tiles = {'checkbox_64.png'},
	group= {snappy=1},

--listener qui met un marqueur à la méta donnée pour éviter les boucles d'évènements
	on_walk_over = function(pos, node, player, blocstart)
	timer.start()
		if (player_meta = minetest.get_meta(blocstart)~='pas passé')
			player_meta:set_string('blocstart','est passé')
		end
	end			
})	

--construction du bloc
minetest.register_craft({
		output = 'new_mod:start_cube',
		recipe = {
			{'default:dirt','default:dirt'},
		}
})
		




