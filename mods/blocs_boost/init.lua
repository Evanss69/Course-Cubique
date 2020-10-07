-- Variables de la durée de chaque boost
dur_vitesse = 3
dur_saut = 3
dur_grav = 5

-- Fonction qui remet la physique du joueur aux valeurs par défaut
function reset_phys(player)
  player:set_physics_override({
    speed = 1.0,
    jump = 1.0,
    gravity = 1.0,
  })
end

-- Bloc de boost de vitesse
minetest.register_node(minetest.get_current_modname()..":boost_vitesse",
{
  description = "Donne un boost de vitesse quand on marche dessus!",
  tiles = {"^[colorize:#378B93"},
  groups = {oddly_breakable_by_hand=1,},
})
local function boost_vitesse(player, pos, node, desc)
  player:set_physics_override({
    speed = 3.0, -- Valeur du multiplicateur de vitesse
    minetest.after(dur_vitesse, reset_phys, player) -- Fin du boost après n secondes
  })
end
minetest.register_node(minetest.get_current_modname()..":boost_vitesse",
{
  description = "Donne un boost de vitesse quand on marche dessus!",
  tiles = {"^[colorize:#00FF00"},
  groups = {oddly_breakable_by_hand=1,},
})
-- Bloc de boost de saut
minetest.register_node(minetest.get_current_modname()..":boost_saut",
{
  description = "Donne un boost de saut quand on marche dessus!",
  tiles = {"^[colorize:#3242A8"},
  groups = {oddly_breakable_by_hand=1,},
})

local function boost_saut(player, pos, node, desc)
  player:set_physics_override({
    jump = 2.0, -- Valeur du multiplicateur de saut
    minetest.after(dur_saut, reset_phys, player) -- Fin du boost après n secondes
  })
end

-- Bloc de boost de réduction de gravité
minetest.register_node(minetest.get_current_modname()..":boost_grav",
{
  description = "Réduit la gravité subie quand on marche dessus!",
  tiles = {"^[colorize:#f5E0AE"},
  groups = {oddly_breakable_by_hand=1,},
})

local function boost_grav(player, pos, node, desc)
  player:set_physics_override({
    gravity = 0.2, -- Valeur du multiplicateur de gravité
    minetest.after(dur_grav, reset_phys, player) -- Fin du boost après n secondes
  })
end

-- Ajout des écouteurs de chaque bloc
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_grav', boost_grav, {'blocs_boost:boost_grav'})
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_saut', boost_saut, {'blocs_boost:boost_saut'})
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_vitesse', boost_vitesse, {'blocs_boost:boost_vitesse'})

