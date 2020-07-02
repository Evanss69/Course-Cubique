local m = mtimer


-- Calculate HUD positions and offsets
--
-- Based on the given named position a table of positional tables is returned
-- by this helper function. When an invalid named position is provided all
-- tables only contain 0 values. Valid positions shown in the diagram below.
--
--   +--------------------------------+
--   | tl            tc            tr |
--   |                                |
--   |                                |
--   | ml            mc            mr |
--   |                                |
--   |                                |
--   | bl            bc            br |
--   +--------------------------------+
--
-- For orientation: `mc` is the center of the screen (where the crosshair is).
--                  `bc` is the location of the hotbar and health bars, etc.
--                  Both are valid positions but should not be used.
--
-- @param pos A positional string as described
-- @return table a Table containing the positional tables based on the string
local get_hud_positions = function (pos)
    local p = { x = 0, y = 0 }
    local a = { x = 0, y = 0 }
    local o = { x = 0, y = 0 }

    if pos == 'tl' then  p = {x=0,  y=0  } a = {x=1, y=1 } o = {x=5, y=3} end
    if pos == 'tc' then  p = {x=0.5,y=0  } a = {x=0, y=1 } o = {x=0, y=3} end
    if pos == 'tr' then  p = {x=1,  y=0  } a = {x=-1,y=1 } o = {x=-6,y=3} end
    if pos == 'ml' then  p = {x=0,  y=0.5} a = {x=1, y=0 } o = {x=5, y=0} end
    if pos == 'mc' then  p = {x=0.5,y=0.5} a = {x=0, y=0 } o = {x=0, y=0} end
    if pos == 'mr' then  p = {x=1,  y=0.5} a = {x=-1,y=0 } o = {x=-6,y=0} end
    if pos == 'bl' then  p = {x=0,  y=1  } a = {x=1, y=-1} o = {x=5, y=0} end
    if pos == 'bc' then  p = {x=0.5,y=1  } a = {x=0, y=-1} o = {x=0, y=0} end
    if pos == 'br' then  p = {x=1,  y=1  } a = {x=-1,y=-1} o = {x=-6,y=0} end

    return { position = p, alignment = a, offset = o }
end


-- Update the timer
--
-- This function updates the timer for the given player referenced by the
-- player’s name. The function is called when a formspec update (fields) is
-- sent to the server and is automatically called by the registered globalstep.
--
-- The function sets the needed values based on the player meta data and uses
-- the `mtimer.get_timer_data` function for the actual data to be shown.
--
-- @param player_name Name of the player to update the timer for
-- @return void
mtimer.update_timer = function (player_name)
    local player = minetest.get_player_by_name(player_name)
    local meta = player:get_meta()
    local m = m.meta
    local hud_id = meta:get_string('mtimer:hud_id')

    local text = mtimer.get_timer_data(player_name).formatted
    local number = meta:get_string(m.color.key):gsub('#', '0x')
    local orientation = get_hud_positions(meta:get_string(m.position.key))

    if meta:get_string(m.visible.key) == 'false' then text = '' end

    player:hud_change(hud_id, 'text', text)
    player:hud_change(hud_id, 'number', number)
    player:hud_change(hud_id, 'position', orientation.position)
    player:hud_change(hud_id, 'alignment', orientation.alignment)
    player:hud_change(hud_id, 'offset', orientation.offset)
end
