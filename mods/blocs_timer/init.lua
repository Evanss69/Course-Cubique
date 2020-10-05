--Propriétés du timer
local timerjeu = Timer(function(elapsed)
  print("fn3: ", elapsed)
end, {
interval = 300, -- Durée maximale du timer
repeats = false, -- Le timer prend fin quand il atteint la valeur interval
})

score = 0

function augmentation_score(player)
  minetest.after(5,function()
		if(timerjeu:is_active()) then
		score = score + 50
		player:hud_change(1,"text",score)
    augmentation_score(player)
		end
  end)
end

function creation_interface(player)
  --Interface score
   hudimage=player:hud_add({
    hud_elem_type = "image",
    position  = {x = 0.9, y = 0.1},
    offset    = {x = -100, y = 0},
    text      = "panneau_score.png",
    scale     = { x = 0.5, y = 0.5},
    alignment = { x = 0, y = 0 },
  })
   hudtexte= player:hud_add({
    hud_elem_type="text",
    text= score,
    position  = {x = 0.9, y = 0.1},
    offset    = {x = -100, y = 0},
    scale     = {x = 100, y = 100},
    alignment = { x = 0, y = 0 },
  })
end

minetest.register_node(minetest.get_current_modname()..":bloc_depart",
{
  description = "Déclenche le timer quand on marche dessus!",
  tiles = {"blocs_timer_depart.png"},
  groups = {oddly_breakable_by_hand=1,},
})

local function depart_timer(player, pos, node, desc)
  if(not timerjeu:is_active()) then
    player:set_pos({x= 0.0, y=30.0, z=14})
    player:set_physics_override({
      gravity = 0.2, 
    })
    creation_interface(player)
    timerjeu:start()
    augmentation_score(player)
    minetest.after(3, function()
      player:set_physics_override({
        gravity = 1, 
      })
    end)
  end
end

minetest.register_node(minetest.get_current_modname()..":bloc_intervalle",
{
  description = "Indique le temps écoulé quand on marche dessus!",
  tiles = {"^[colorize:#ff3b4f"},
  groups = {oddly_breakable_by_hand=1,},
})

local function temps_ecoule(player, pos, node, desc)
    minetest.chat_send_all(timerjeu:get_elapsed())
end

minetest.register_node(minetest.get_current_modname()..":bloc_fin",
{
  description = "Arrête le timer quand on marche dessus!",
  tiles = {"blocs_timer_arrivee.png"},
  groups = {oddly_breakable_by_hand=1,},
})

local function fin_timer(player, pos, node, desc)
  if (timerjeu:is_active()) then
    --Obternir le temps au 100e de seconde près
    local temps = math.floor(timerjeu:get_elapsed()*100)/100
    --Calcul du score
    local nb = blocs_fragiles.get_nb_blocs()
    local score_blocs = nb*100
    local score_total = score + score_blocs

    timerjeu:stop()
    timerjeu:expire()
    player:hud_remove(hudimage)
    player:hud_remove(hudtexte)
    local hudimgfin=player:hud_add({
      hud_elem_type = "image",
      position  = {x = 0.5, y = 0.5},
      offset    = {x = 0, y = -200},
      text      = "panneau_score.png",
      scale     = { x = 1.5, y = 1.5},
      alignment = { x = 0, y = 0 },
    })
    local hudtextfin=player:hud_add({
      hud_elem_type="text",
      text= "Temps : "..temps.." secondes \nNombre de blocs passés : "..nb
      .."\nScore total : "..score.." + "..score_blocs.." = "..score_total,
      position  = {x = 0.5, y = 0.5},
      offset    = {x = 0, y = -200},
      scale     = {x = 100, y = 100},
      alignment = { x = 0, y = 0 },
    })
    blocs_fragiles.set_nb_blocs(0)
    minetest.after(10,function()
      player:hud_remove(hudimgfin)
      player:hud_remove(hudtextfin)
      player:setpos({x=0, y=5, z=0})
    end)
  end
end

-- Ajout des écouteurs de chaque bloc
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_depart', depart_timer, {'blocs_timer:bloc_depart'})
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_intervalle', temps_ecoule, {'blocs_timer:bloc_intervalle'})
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_fin', fin_timer, {'default:water_source'})