-- # vim: nowrap
--
-- Set Vim to no-wrapping mode because of some lines not fitting within the 80
-- characters width limit due to overall readability of the code.


-- Localise needed functions
local m = mtimer
local S = m.translator
local build_frame = m.build_frame
local fe = minetest.formspec_escape


-- Formspecs are loaded and shown by individual functions. The function name
-- correlates with the formspec to show. All of the names are self-explanatory
-- and within the functions no logic is used.
--
-- @see mtimer.show_formspec
-- @see mtimer.get_times
-- @see ./system/on_receive_fields.lua
-- @see ./system/chat_command.lua
-- @see https://dev.minetest.net/formspec


mtimer.dialog.main_menu = function (player_name)
    mtimer.show_formspec('mtimer:main_menu', {
        title = S('mTimer'),
        width = 9.75,
        height = 6,
        prefix = '',
        add_buttons = false,
        show_to = player_name,
        formspec = {
            'container[0,0]',
            'label[0,0;'..S('Visuals')..']',
            'button[0,0.25;3,0.5;set_visibility;'..S('Visibility')..']',
            'button[0,1;3,0.5;set_position;'..S('Position')..']',
            'button[0,1.75;3,0.5;set_color;'..S('Color')..']',
            'container_end[]',
            'container[3.25,0]',
            'label[0,0;'..S('Time Representation')..']',
            'button[0,0.25;3,0.5;ingame_time_format;'..S('Ingame Time Format')..']',
            'button[0,1;3,0.5;real_world_time_format;'..S('Real-World Time Format')..']',
            'button[0,1.75;3,0.5;session_start_time_format;'..S('Session Start Time Format')..']',
            'button[0,2.5;3,0.5;session_duration_format;'..S('Session Duration Format')..']',
            'button[0,3.25;3,0.5;host_time_format;'..S('Host Time Format')..']',
            'container_end[]',
            'container[6.5,0]',
            'label[0,0;'..S('Timer Configuration')..']',
            'button[0,0.25;3,0.5;timer_format;'..S('Timer Format')..']',
            'button[0,1;3,0.5;timezone_offset;'..S('Timezone Offset')..']',
            'container_end[]',
            'container[0,4.125]',
            'box[0,0;+linewidth,0.04;#ffffff]',
            'button[4.3,0.225;2.5,0.5;reset_everything;'..S('Reset Everything')..']',
            'button_exit[7,0.225;2.5,0.5;exit;'..S('Exit')..']',
            'container_end[]'
        }
    })
end


mtimer.dialog.set_visibility = function (player_name)
    mtimer.show_formspec('mtimer:set_visibility', {
        title = S('Visibility'),
        show_to = player_name,
        formspec = {
            'button[0,0;3,0.5;visible;'..S('Visible')..']',
            'button[3.25,0;3,0.5;invisible;'..S('Invisible')..']'
        }
    })
end


mtimer.dialog.set_position = function (player_name)
    mtimer.show_formspec('mtimer:set_position', {
        title = S('Position'),
        height = 5.35,
        width = 8.25,
        show_to = player_name,
        formspec = {
            'image_button[0,0;8,4.5 ;mtimer_positions_orientation.png;pos_xx;;;false]',
            'image_button[0,0;2.67,1.5;mtimer_transparent.png;pos_tl;;;false]',         -- TL
            'image_button[2.67,0;2.67,1.5;mtimer_transparent.png;pos_tc;;;false]',      -- TC
            'image_button[5.34,0;2.67,1.5;mtimer_transparent.png;pos_tr;;;false]',      -- TR
            'image_button[0,1.5;2.67,1.5;mtimer_transparent.png;pos_ml;;;false]',       -- ML
            'image_button[2.67,1.5;2.67,1.5;mtimer_transparent.png;pos_mc;;;false]',    -- MC
            'image_button[5.34,1.5;2.67,1.5;mtimer_transparent.png;pos_mr;;;false]',    -- MR
            'image_button[0,3;2.67,1.5;mtimer_transparent.png;pos_bl;;;false]',         -- BL
            'image_button[2.67,3;2.67,1.5;mtimer_transparent.png;pos_bc;;;false]',      -- BC
            'image_button[5.34,3;2.67,1.5;mtimer_transparent.png;pos_br;;;false]',      -- BR
            'label[0,4.75;'..S('Click the position you want to place the timer at.')..']'
        }
    })
end


mtimer.dialog.set_color = function (player_name)
    local player = minetest.get_player_by_name(player_name)
    local color = player:get_meta():get_string(m.meta.color.key)

    local hexcolor = table.concat({
        '#',
        minetest.colorize('#ce5c00', 'rr'),
        minetest.colorize('#4e9a06', 'gg'),
        minetest.colorize('#729fcf', 'bb')
    })

    mtimer.show_formspec('mtimer:set_color', {
        title = S('Color'),
        show_to = player_name,
        formspec = {
            'field_close_on_enter[color;false]',
            'field[0,0;3,0.5;color;;'..color..']',
            'box[3.25,0;0.5,0.5;'..color..'ff]',
            'label[0.025,0.75;'..S('Use `@1` format only!', hexcolor)..']'
        }
    })
end


mtimer.dialog.timezone_offset = function (player_name)
    local time_data = mtimer.get_times(player_name).real_time

    local format = {
        conversion = S('30 minutes @= 0.5, 60 minutes @= 1'),
        arbitrarity = S('“Arbitrary” values are possible.')
    }

    local time_information = {
        s = S('Server Time: @1', time_data.times.server_time),
        l = S('Local Time: @1', time_data.times.local_time)
    }

    mtimer.show_formspec('mtimer:timezone_offset', {
        title = S('Timezone Offset'),
        show_to = player_name,
        formspec = {
            'field_close_on_enter[offset;false]',
            'field[0,0;3,0.5;offset;;'..time_data.times.offset..']',
            'container[3.25,0.1]',
            'label[0,0;'..format.conversion..']',
            'label[0,0.3;'..format.arbitrarity..']',
            'container_end[]',
            'container[0,0.9]',
            'label[0,0;'..time_information.s..']',
            'label[0,0.3;'..time_information.l..']',
            'container_end[]'
        }
    })
end


mtimer.dialog.ingame_time_format = function (player_name)
    local time_data = mtimer.get_times(player_name).ingame_time

    mtimer.show_formspec('mtimer:ingame_time_format', {
        title = S('Ingame Time Format'),
        height = 3.8,
        show_to = player_name,
        formspec = {
            'field_close_on_enter[format;false]',
            'field[0,0;+linewidth,0.5;format;;'..fe(time_data.format)..']',
            'container[0,0.9]',
            'label[2.8,0;'..S('Variable')..']',
            'label[4.25,0;'..S('Current Value')..']',
            'box[0,0.25;+linewidth,0.02;#ffffff]',
            'label[0,0.5;'..S('Hours (24h)')..']       label[2.8,0.5;{24h}]  label[4.25,0.5;'..time_data.hours_24..']',
            'label[0,0.9;'..S('Hours (12h)')..']       label[2.8,0.9;{12h}]  label[4.25,0.9;'..time_data.hours_12..']',
            'label[0,1.3;'..S('Minutes')..']           label[2.8,1.3;{min}]  label[4.25,1.3;'..time_data.minutes..']',
            'label[0,1.7;'..S('Ingame Timestamp')..']  label[2.8,1.7;{its}]  label[4.25,1.7;'..time_data.ingame_timestamp..']',
            'box[0,2;+linewidth,0.02;#ffffff]',
            'label[0,2.25;'..S('Current Result')..']',
            'label[2.8,2.25;'..fe(time_data.formatted)..']',
            'container_end[]'
        }
    })
end


mtimer.dialog.real_world_time_format = function (player_name)
    mtimer.dialog.real_time_universal(player_name, {
        time_type = 'real_time',
        formspec_name = 'mtimer:real_world_time_format',
        title = S('Real-World Time Format')
    })
end


mtimer.dialog.host_time_format = function (player_name)
    mtimer.dialog.real_time_universal(player_name, {
        time_type = 'host_time',
        formspec_name = 'mtimer:host_time_format',
        title = S('Host Time Format')
    })
end


mtimer.dialog.session_start_time_format = function (player_name)
    mtimer.dialog.real_time_universal(player_name, {
        time_type = 'session_start_time',
        formspec_name = 'mtimer:session_start_time_format',
        title = S('Session Start Time Format')
    })
end


mtimer.dialog.session_duration_format = function (player_name)
    local time_data = mtimer.get_times(player_name).session_duration

    mtimer.show_formspec('mtimer:session_duration_format', {
        title = S('Session Duration Format'),
        show_to = player_name,
        height = 3.8,
        formspec = {
            'field_close_on_enter[format;false]',
            'field[0,0;+linewidth,0.5;format;;'..fe(time_data.format)..']',
            'container[0,0.9]',
            'label[2.5,0;'..S('Variable')..']',
            'label[4,0;'..S('Current Value')..']',
            'box[0,0.25;+linewidth,0.02;#ffffff]',
            'label[0,0.5;'..S('Days')..']     label[2.5,0.5;{days}]     label[4,0.5;'..time_data.days..']',
            'label[0,0.9;'..S('Hours')..']    label[2.5,0.9;{hours}]    label[4,0.9;'..time_data.hours..']',
            'label[0,1.3;'..S('Minutes')..']  label[2.5,1.3;{minutes}]  label[4,1.3;'..time_data.minutes..']',
            'label[0,1.7;'..S('Seconds')..']  label[2.5,1.7;{seconds}]  label[4,1.7;'..time_data.seconds..']',
            'box[0,2;+linewidth,0.02;#ffffff]',
            'label[0,2.25;'..S('Current Result')..']',
            'label[2.5,2.25;'..fe(time_data.formatted)..']',
            'container_end[]'
        }
    })
end


mtimer.dialog.timer_format = function (player_name)
    local timer_data = mtimer.get_timer_data(player_name)

    mtimer.show_formspec('mtimer:timer_format', {
        title = S('Timer Format'),
        show_to = player_name,
        height = 5.75,
        width = 8.5,
        formspec = {
            'textarea[0,0;6,2.5;format;;'..fe(timer_data.format)..']',
            'container[0,2.9]',
            'label[2.5,0;'..S('Variable')..']',
            'label[4,0;'..S('Current Value')..']',
            'box[0,0.25;+linewidth,0.02;#ffffff]',
            'label[0,0.5;'..S('Real-World Date')..']     label[2.5,0.5;{rd}]  label[4,0.5;'..fe(timer_data.real_world_date)..']',
            'label[0,0.9;'..S('In-Game Time')..']        label[2.5,0.9;{it}]  label[4,0.9;'..fe(timer_data.ingame_time)..']',
            'label[0,1.3;'..S('Session Start Time')..']  label[2.5,1.3;{st}]  label[4,1.3;'..fe(timer_data.session_start_time)..']',
            'label[0,1.7;'..S('Session Duration')..']    label[2.5,1.7;{sd}]  label[4,1.7;'..fe(timer_data.session_duration)..']',
            'label[0,2.1;'..S('Host Time')..']           label[2.5,2.1;{ht}]  label[4,2.1;'..fe(timer_data.host_time)..']',
            'container_end[]',
            'container[6.25,0]',
            'button[0,0;2,0.5;apply;'..S('Apply')..']',
            'container_end[]'
        }
    })
end
