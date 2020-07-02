local m = mtimer
local d = mtimer.dialog


-- When formspec data is sent to the server check for the formname and run the
-- specific action for the given form. See Individual descriptions. The code
-- for this is very simple because most of the logic is handled in the
-- timer functions and not in the formspec code.
minetest.register_on_player_receive_fields(function(player, formname, fields)
    local meta = player:get_meta()
    local name = player:get_player_name()


    -- Select what formspec to show basing on main menu button
    if formname == 'mtimer:main_menu' then
        if fields.set_visibility then d.set_visibility(name) end
        if fields.set_position then d.set_position(name) end
        if fields.set_color then d.set_color(name) end
        if fields.timezone_offset then d.timezone_offset(name) end
        if fields.ingame_time_format then d.ingame_time_format(name) end
        if fields.real_world_time_format then d.real_world_time_format(name) end
        if fields.host_time_format then d.host_time_format(name) end
        if fields.session_start_time_format then
            d.session_start_time_format(name)
        end
        if fields.session_duration_format then
            d.session_duration_format(name)
        end
        if fields.timer_format then d.timer_format(name) end
    end


    -- Set timer visibility
    if formname == 'mtimer:set_visibility' then
        local attr = m.meta.visible
        if fields.visible then meta:set_string(attr.key, 'true') end
        if fields.invisible then meta:set_string(attr.key, 'false') end
        if fields.default then meta:set_string(attr.key, attr.default) end
    end


    -- Set timer position
    if formname == 'mtimer:set_position' then
        local attr = m.meta.position
        for p,_ in pairs(fields) do
            if p == 'default' then
                meta:set_string(attr.key, attr.default)
            elseif p:gsub('_.*', '') == 'pos' then
                local new_pos = p:gsub('pos_', '')
                if new_pos ~= 'xx' then meta:set_string(attr.key, new_pos) end
            end
        end
    end


    -- Set timer text color
    if formname == 'mtimer:set_color' then
        local attr = m.meta.color
        local color = ''

        if fields.color then
            local valid = fields.color:match('^#'..('[0-9a-fA-F]'):rep(6)..'$')
            local color = valid and fields.color or attr.default
            meta:set_string(attr.key, color)
        end

        if fields.default then meta:set_string(attr.key, attr.default) end
        if not fields.quit then d.set_color(name) end
    end


    -- Configure timezone offset
    if formname == 'mtimer:timezone_offset' then
        local attr = m.meta.timezone_offset
        local value = tonumber(fields.offset) or attr.default
        if math.abs(value) > os.time() then value = 0 end
        meta:set_string(attr.key, value)
        if fields.default then meta:set_string(attr.key, attr.default) end
        if not fields.quit then d.timezone_offset(name) end
    end


    -- Set ingame time format
    if formname == 'mtimer:ingame_time_format' then
        local attr = m.meta.ingame_time
        local value = fields.format or attr.default
        meta:set_string(attr.key, value)
        if fields.default then meta:set_string(attr.key, attr.default) end
        if not fields.quit then d.ingame_time_format(name)end
    end


    -- Set real-time format
    if formname == 'mtimer:real_world_time_format' then
        local attr = m.meta.real_time
        local value = fields.format or attr.default
        meta:set_string(attr.key, value)
        if fields.default then meta:set_string(attr.key, attr.default) end
        if not fields.quit then d.real_world_time_format(name) end
    end


    -- Set host time format
    if formname == 'mtimer:host_time_format' then
        local attr = m.meta.host_time
        local value = fields.format or attr.default
        meta:set_string(attr.key, value)
        if fields.default then meta:set_string(attr.key, attr.default) end
        if not fields.quit then d.host_time_format(name) end
    end


    -- Set session start time format
    if formname == 'mtimer:session_start_time_format' then
        local attr = m.meta.session_start_time
        local value = fields.format or attr.default
        meta:set_string(attr.key, value)
        if fields.default then meta:set_string(attr.key, attr.default) end
        if not fields.quit then d.session_start_time_format(name)  end
    end


    -- Set session duration format
    if formname == 'mtimer:session_duration_format' then
        local attr = m.meta.session_duration
        local value = fields.format or attr.default
        meta:set_string(attr.key, value)
        if fields.default then meta:set_string(attr.key, attr.default) end
        if not fields.quit then d.session_duration_format(name) end
    end


    -- Set timer text
    if formname == 'mtimer:timer_format' then
        local attr = m.meta.timer_format
        local value = fields.format or attr.default
        meta:set_string(attr.key, value)
        if fields.default then meta:set_string(attr.key, attr.default) end
        if not fields.quit then d.timer_format(name) end
    end


    -- Back to menu from all formspecs and conditionally update timer
    if fields.main_menu then d.main_menu(name) end
    if formname ~= 'mtimer:main_menu' then m.update_timer(name) end


    -- Reset everything
    if fields.reset_everything then
        for _,def in pairs(m.meta) do
            meta:set_string(def.key, def.default)
        end
    end


end)
