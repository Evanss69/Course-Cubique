minetest.register_node(minetest.get_current_modname()..":boost_vitesse",
{
  description = "Donne un boost de vitesse quand on marche dessus!",
  tiles = {"^[colorize:#802BB1"},
})

local function boost_vitesse(player, pos, node, desc)
  player:set_physics_override({
    speed = 3.0,
  })
end

minetest.register_node(minetest.get_current_modname()..":boost_saut",
{
  description = "Donne un boost de saut quand on marche dessus!",
  tiles = {"^[colorize:#3242A8"},
})

local function boost_saut(player, pos, node, desc)
  player:set_physics_override({
    jump = 2.0,
  })
end

poschangelib.add_player_walk_listener('blocs_boost:ecouteur_saut', boost_saut, {'blocs_boost:boost_saut'})
poschangelib.add_player_walk_listener('blocs_boost:ecouteur_vitesse', boost_vitesse, {'blocs_boost:boost_vitesse'})