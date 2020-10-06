-- Ce script assure que le joueur apparaisse à la même position après une mort ou quand il rejoint
minetest.register_on_respawnplayer(function(player)
    player:setpos({x=0, y=5, z=0})
    player:set_look_horizontal(math.pi)
    player:set_look_vertical(-0.5)
    return true
end)

minetest.register_on_newplayer(function(player)
    player:setpos({x=0, y=5, z=0})
    player:set_look_horizontal(math.pi)
    player:set_look_vertical(-0.5)
    return true
end)

minetest.register_on_joinplayer(function(player)
    player:setpos({x=0, y=5, z=0})
    player:set_look_horizontal(math.pi)
    player:set_look_vertical(-0.5)
    return true
end)