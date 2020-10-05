-- Morceau de code nécessaire pour créer des fonctions accessibles depuis d'autres scripts
blocs_fragiles = {}

minetest.register_node(minetest.get_current_modname()..":bloc_fragile_normal",
{
  description = "Un bloc normal sans propriétés particulières.",
  tiles = {"bloc_normal.png"},
  groups = {oddly_breakable_by_hand=1,},
})

minetest.register_node(minetest.get_current_modname()..":bloc_fragile_normal_disp",
{
  drawtype = glasslike,
  use_texture_alpha = true,
  description = "Ce bloc est en train de disparaitre!",
  tiles = {"bloc_normal_disp.png"},
  groups = {oddly_breakable_by_hand=1,},
})

minetest.register_node(minetest.get_current_modname()..":bloc_fragile_bond",
{
  description = "Propulse le joueur en l'air quand on marche dessus!",
  tiles = {"bloc_bond.png"},
  groups = {oddly_breakable_by_hand=1,},
})

minetest.register_node(minetest.get_current_modname()..":bloc_fragile_bond_disp",
{
  drawtype = glasslike,
  use_texture_alpha = true,
  description = "Ce bloc est en train de disparaitre!",
  tiles = {"bloc_bond_disp.png"},
  groups = {oddly_breakable_by_hand=1,},
})

minetest.register_node(minetest.get_current_modname()..":bloc_fragile_gliss",
{
  description = "Un bloc glissant!",
  tiles = {"bloc_glissant.png"},
  groups = {oddly_breakable_by_hand=1, slippery = 3},
})

minetest.register_node(minetest.get_current_modname()..":bloc_fragile_gliss_disp",
{
  drawtype = glasslike,
  use_texture_alpha = true,
  description = "Ce bloc est en train de disparaitre!",
  tiles = {"bloc_glissant_disp.png"},
  groups = {oddly_breakable_by_hand=1, slippery = 3},
})

-- Fonction qui fait réapparaître un bloc du nom donné à proximité de la position donnée
local function reapparition_bloc(pos, node_name)
  -- Positions des limites de la zone à "fouiller" pour des blocs libres
  local pos1 = {x = pos.x + 2, y = pos.y, z = pos.z + 2}
  local pos2 = {x = pos.x - 2, y = pos.y, z = pos.z - 2}
  -- Table qui contient les blocs libres a proximité
  local blocs_libres = minetest.find_nodes_in_area(pos1, pos2, "air")
  -- Vérifie qu'au moins un bloc libre a été trouvé puis remplace l'un d'entre eux aléatoirement
  if blocs_libres ~= nil then
    pos = blocs_libres[math.random(#blocs_libres)]
    minetest.set_node(pos, {name = node_name})
  end
end

local nb_blocs = 0
-- Fonction qui fait disparaître un bloc en le remplaçant par un bloc d'air après quelques secondes
local function disparition_bloc(player, pos, node, desc)
  -- Transforme le bloc en sa version disparaîssante
  minetest.set_node(pos, {name = node.name.."_disp"})
  minetest.after(3, function()
    minetest.set_node(pos, {name = "air"})
    reapparition_bloc(pos, node.name)
  end)
  nb_blocs = nb_blocs + 1
end

-- Fonction qui propulse le joueur en l'air puis fait disparaître le bloc
local function bond(player, pos, node, desc)
  player:add_player_velocity({x=0, y=20, z=0})
  disparition_bloc(player, pos, node, desc)
end

-- Ajouter un effet quand un joueur marche sur le bloc
poschangelib.add_player_walk_listener("blocs_fragiles:ecouteur_bfn", disparition_bloc, {'blocs_fragiles:bloc_fragile_normal'})
poschangelib.add_player_walk_listener("blocs_fragiles:ecouteur_bfb", bond, {'blocs_fragiles:bloc_fragile_bond'})
poschangelib.add_player_walk_listener("blocs_fragiles:ecouteur_bfg", disparition_bloc, {'blocs_fragiles:bloc_fragile_gliss'})

-- Getter et Setter nombre de blocs sur lesquels le joueur est passé
function blocs_fragiles.get_nb_blocs()
  return(nb_blocs)
end

function blocs_fragiles.set_nb_blocs(n)
  nb_blocs=n
end

