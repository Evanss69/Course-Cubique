
--Propriétés du timer
local timerjeu2 = Timer(function(elapsed)
  print("fn3: ", elapsed)
end, {
interval = 300, -- Durée maximale du timer
repeats = false, -- Le timer prend fin quand il atteint la valeur interval
})


score=1500

function diminution_score()
  minetest.after(10,function()
		if(timerjeu2:is_active()) then
		score=score-5
    diminution_score()
		end
  end	)
	
end
	



minetest.register_node(minetest.get_current_modname()..":bloc_depart",
{
  description = "Déclenche le timer quand on marche dessus!",
  tiles = {"blocs_timer_depart.png"},
  groups = {oddly_breakable_by_hand=1,},
})

local function depart_timer(player, pos, node, desc)
    timerjeu2:start()
    diminution_score()
end

minetest.register_node(minetest.get_current_modname()..":bloc_intervalle",
{
  description = "Indique le temps écoulé quand on marche dessus!",
  tiles = {"^[colorize:#ff3b4f"},
  groups = {oddly_breakable_by_hand=1,},
})

local function temps_ecoule(player, pos, node, desc)
    minetest.chat_send_all(timerjeu2:get_elapsed())
end

minetest.register_node(minetest.get_current_modname()..":bloc_fin",
{
  description = "Arrête le timer quand on marche dessus!",
  tiles = {"blocs_timer_arrivee.png"},
  groups = {oddly_breakable_by_hand=1,},
})

local function fin_timer(player, pos, node, desc)
    minetest.chat_send_all('Temps écoulé: ')
    minetest.chat_send_all(timerjeu2:get_elapsed())
    timerjeu2:stop()
    timerjeu2:expire()
    minetest.chat_send_all("Ton score est :")
    minetest.chat_send_all(score)
end

-- Ajout des écouteurs de chaque bloc
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_depart', depart_timer, {'blocs_timer:bloc_depart'})
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_intervalle', temps_ecoule, {'blocs_timer:bloc_intervalle'})
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_fin', fin_timer, {'blocs_timer:bloc_fin'})