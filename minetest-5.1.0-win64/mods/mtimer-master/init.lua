local modpath = minetest.get_modpath('mtimer')..DIR_DELIM
local syspath = modpath..'system'..DIR_DELIM
local S = minetest.get_translator('mtimer')


-- Set initial global `mtimer` table
--
-- The sub-table `dialog` is filled programmatically and is used for the
-- functions that show the formspecs to the player.
--
-- In sub-table `meta` the meta keys and their default values are defined. Those
-- are iterated over when a player joins. The names are searched for whenever
-- somewhere in the code a meta information is to be loaded.
--
-- @see ./system/formspec/formspec_creation.lua
mtimer = {
    translator = S,
    dialog = {},
    meta = {
        visible = { key = 'mtimer:visible', default = 'true' },
        position = { key = 'mtimer:position', default = 'bl' },
        color = { key = 'mtimer:color', default = '#ffffff' },
        timezone_offset = { key = 'mtimer:timezone_offset', default = '0' },
        ingame_time = {
            key = 'mtimer:ingame_time_format',
            default = '{24h}:{min}'
        },
        real_time = {
            key = 'mtimer:real_time_format',
            default = '{24h}:{min} ({isodate})'
        },
        host_time = {
            key = 'mtimer:host_time_format',
            default = '{24h}:{min} ({isodate})'
        },
        session_start_time = {
            key = 'mtimer:session_start_time_format',
            default = '{isodate}T{isotime}'
        },
        session_duration = {
            key = 'mtimer:session_duration_format',
            default = '{hours}:{minutes}'
        },
        timer_format = {
            key = 'mtimer:timer_format',
            default = table.concat({
                S('Current Date: @1', '{rd}'),
                S('Ingame Time: @1', '{it}'),
                S('Session Start: @1', '{st}'),
                S('Session Duration: @1', '{sd}')
            }, '\n')
        }
    }
}


-- Load formspec functionality
dofile(syspath..'formspec'..DIR_DELIM..'formspec_helpers.lua')
dofile(syspath..'formspec'..DIR_DELIM..'real_time_universal.lua')
dofile(syspath..'formspec'..DIR_DELIM..'formspec_creation.lua')


-- Load system
dofile(syspath..'chat_command.lua')
dofile(syspath..'update_timer.lua')
dofile(syspath..'on_receive_fields.lua')
dofile(syspath..'on_joinplayer.lua')
dofile(syspath..'get_times.lua')
dofile(syspath..'get_timer_data.lua')
dofile(syspath..'register_globalstep.lua')
