minetest.register_on_joinplayer(function(player)

	    local player_meta = player:get_meta()
		player:set_attribute("score", 10000)
--création d'un nouveau bloc arrivé
minetest.register_mode('new_mod:arrive_cube',{
	description={'bloc arrivé'},
	tiles = {'error_screenshot.png'},
	group= {snappy=1},
	on_walk_over = local function(pos, node, player, blocstart)
		if (local player_meta = minetest.get_meta(blocstart)=='est passé'){
			player_meta:set_string('blocstart','pas passé'),
			
		end
		
	end	
on_rightclick =
				function update_score (player,timer_deb,timer_fin)
				local player_score = player_meta:get_string(score)
				local durée = timer_deb - timer_fin
				player_score = player_score - (durée*12)
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