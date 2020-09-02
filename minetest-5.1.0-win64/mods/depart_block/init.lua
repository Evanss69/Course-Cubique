--initialisation de la m�ta donn�e � l'apparition du joueur
minetest.register_on_joinplayer(function(player)
	minetest.get_meta(player)
	player:set_attribut('blockstart', true)
	end)

--suppression de la m�tadonn�e lorsqu'on quitte minetest
minetest.register_on_leaveplayer(function(player)
	minetest.get_meta(player):set_string('blockstart', nil)
	end)

--cr�ation d'un nouveau bloc de d�part
minetest.register_mode('new_mod:start_cube',{
	description={'bloc d�part'},
	tiles = {'checkbox_64.png'},
	group= {snappy=1},

--listener qui met un marqueur � la m�ta donn�e pour �viter les boucles d'�v�nements
	on_walk_over = function(pos, node, player, blocstart)
	timer.start()
		if (player_meta = minetest.get_meta(blocstart)~='pas pass�')
			player_meta:set_string('blocstart','est pass�')
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
		




