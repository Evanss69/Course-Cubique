minetest.register_on_joinplayer(function(player)

	    local player_meta = player:get_meta()
		player:set_attribute("score", 10000)
--cr�ation d'un nouveau bloc arriv�
minetest.register_mode('new_mod:arrive_cube',{
	description={'bloc arriv�'},
	tiles = {'error_screenshot.png'},
	group= {snappy=1},
	on_walk_over = local function(pos, node, player, blocstart)
		if (local player_meta = minetest.get_meta(blocstart)=='est pass�'){
			player_meta:set_string('blocstart','pas pass�'),
			
		end
		
	end	
on_rightclick =
				function update_score (player,timer_deb,timer_fin)
				local player_score = player_meta:get_string(score)
				local dur�e = timer_deb - timer_fin
				player_score = player_score - (dur�e*12)
				player:set_attribute("score", player_score)
				return player_score
			end 	
})

 
--construction du bloc
minetest.register_craft({
		output = 'new_mod:arrive_cube',
		recipe = {
			{'default:dirt'},
		}
})