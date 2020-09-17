minetest.register_node(minetest.get_current_modname()..":bloc_fragile_normal",
{
  description = "Disparait après quelques secondes quand on marche dessus!",
  tiles = {"^[colorize:#e58703"},
  groups = {oddly_breakable_by_hand=1,},
})

minetest.register_node(minetest.get_current_modname()..":bloc_fragile_normal_disp",
{
  description = "Ce bloc est en train de disparaitre!",
  tiles = {"^[colorize:#5f3901"},
  groups = {oddly_breakable_by_hand=1,},
})

-- Fonction qui fait réapparaître un bloc du nom donné à proximité de la position donnée
local function reapparition_bloc(pos, node_name)
  -- Réappariton d'un bloc à une position aléatoire à proximité du bloc disparu
  local pos = {x = pos.x + math.random(0,6) - 3, y = pos.y, z = pos.z + math.random(0,6) - 3}
  minetest.set_node(pos, {name = node_name})
end

local nb_blocs = 1
-- Fonction qui fait disparaître un bloc en le remplaçant par un bloc d'air après quelques secondes
local function disparition_bloc(player, pos, node, desc)
  minetest.set_node(pos, {name = "blocs_fragiles:bloc_fragile_normal_disp"})
  minetest.after(3, function()
    minetest.set_node(pos, {name = "air"})
    reapparition_bloc(pos, "blocs_fragiles:bloc_fragile_normal")
  end)
  nb_blocs = nb_blocs + 1
  -- minetest.chat_send_all(nb_blocs)
end

-- Ajouter un effet quand un joueur marche sur le bloc
poschangelib.add_player_walk_listener("blocs_fragiles:ecouteur_bfn", disparition_bloc, {'blocs_fragiles:bloc_fragile_normal'})

-- Retourne le nombre de blocs sur lesquels le joueur est passé
function get_nb_blocs()
  return(nb_blocs)
end