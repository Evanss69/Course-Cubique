local m = mtimer


-- When a player joins
--
-- 1. Set default values if not set
-- 2. Set session start timestamp
-- 3. Set “empty” HUD element and write ID to meta data for later use
minetest.register_on_joinplayer(function(player)
    local meta = player:get_meta()

    for _,def in pairs(m.meta) do
        local current = meta:get_string(def.key)
        if current == '' then meta:set_string(def.key, def.default) end
    end

    meta:set_string('mtimer:session_start', os.time())

    meta:set_string('mtimer:hud_id', player:hud_add({
        hud_elem_type = 'text',
        text = '',
        number = '0x000000',
        position = {x=0,y=0},
        alignment = {x=0,y=0},
        offset = {x=0,y=0}
    }))
end)
