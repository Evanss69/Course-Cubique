score = {}
local saved_huds = {}

function score.update_hud(player)
    local player_name = player:get_player_name()

    -- Get the dig and place count from storage, or default to 0
    local meta        = player:get_meta()
    local digs_text   = "Digs: " .. meta:get_int("score:digs")
    local places_text = "Places: " .. meta:get_int("score:places")
    local percent     = tonumber(meta:get("score:score") or 0.2)
player:hud_add({
    hud_elem_type = "text",
    position  = {x = 0, y = 0.5},
    offset    = {x = 5, y = 0},
    text      = "Stats \n"..digs_text.."\n"..places_text,
    alignment = {x = 1, y = 0},
    scale     = { x = 100, y = 100},
    number    = 0xFFFFFF,
})
--[[
player:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = 0, y = 0},
    text      = digs_text,
    alignment = -1,
    scale     = { x = 100, y = 100},
    number    = 0xFFFFFF,
})

player:hud_add({
    hud_elem_type = "text",
    position  = {x = 1, y = 0.5},
    offset    = {x = -70, y = 0},
    text      = places_text,
    alignment = -1,
    scale     = { x = 50, y = 10},
    number    = 0xFFFFFF,
})
player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -220, y = 0},
    text      = "score_background.png",
    scale     = { x = 1, y = 1},
    alignment = { x = 1, y = 0 },
})
player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -215, y = 23},
    text      = "score_bar_empty.png",
    scale     = { x = 1, y = 1},
    alignment = { x = 1, y = 0 },
})

player:hud_add({
    hud_elem_type = "image",
    position  = {x = 1, y = 0.5},
    offset    = {x = -215, y = 23},
    text      = "score_bar_full.png",
    scale     = { x = percent, y = 1},
    alignment = { x = 1, y = 0 },
})
]]
    local ids = saved_huds[player_name]
    if ids then
        player:hud_change(ids["places"], "text", places_text)
        player:hud_change(ids["digs"],   "text", digs_text)
        player:hud_change(ids["bar_foreground"],
                "scale", { x = percent, y = 1 })
    else
        ids = {}
        saved_huds[player_name] = ids

        -- create HUD elements and set ids into `ids`
    end
end

minetest.register_on_joinplayer(score.update_hud)

minetest.register_on_leaveplayer(function(player)
    saved_huds[player:get_player_name()] = nil
end)