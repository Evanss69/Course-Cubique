    local player = minetest.get_player_by_name(player_name)
	    local player_meta = player:get_meta()
		player:set_attribute("score", 10000)


--[[
function update_score (player,timer_deb,timer_fin)
local player_score = player_meta:get_string(score)
local durée = timer_deb - timer_fin
player_score = player_score - (durée*12)
player:set_attribute("score", "player_score")
return player_score
end ) 
]]