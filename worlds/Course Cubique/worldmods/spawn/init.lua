-- Ce script assure que le joueur apparaisse à la même position après une mort ou quand il rejoint
minetest.register_on_respawnplayer(function(player)
    player:setpos({x=0, y=5, z=0})
    return true
end)

minetest.register_on_newplayer(function(player)
    player:setpos({x=0, y=5, z=0})
    return true
end)

minetest.register_on_joinplayer(function(player)
    player:setpos({x=0, y=5, z=0})
    return true
end)