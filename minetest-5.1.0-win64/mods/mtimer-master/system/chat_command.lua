local m = mtimer
local S = m.translator
local d = m.dialog
local cs = minetest.chat_send_player


-- Colorize a command sequence
--
-- This function returns a colorized chat command sequence with the given
-- parameter and the needed spacing
--
-- @param command The chat command paramter
-- @return table  The colorized string
local command = function (command)
     return minetest.colorize('cyan', '/mtimer '..command..'   ')
end


-- Chat command
--
-- The `/mtimer` chat command opens the main menu and allows to directly open
-- the formspecs for the specific configuration. It can be run by all users.
--
-- The following parameters are supported.
--
--  Parameter   Mnemonic           Action
-- -------------------------------------------------------------------
--  vi          visibility         d.set_visibility(name)
--  po          position           d.set_position(name)
--  co          color              d.sec_color(name)
--  tz          timezone           d.timezone_offset(name)
--  in          ingame             d.ingame_time_format(name)
--  re          real               d.real_world_time_format(name)
--  ht          host time          d.host_time_format(name)
--  st          start time         d.session_start_time_format(name)
--  sd          session duration   d.session_duration_format(name)
--  tf          timer format       d.timer_format(name)
-- -------------------------------------------------------------------
--  help        Prints the help output showing the parameters
--
-- Providing unknown parameters has no effect.
minetest.register_chatcommand('mtimer', {
    description = S('Configure timer display'),
    params = '<vi/po/co/tz/in/re/st/sd/tt/help>',
    func = function(name, parameters)
        local action = parameters:match('%a+')

        if not minetest.get_player_by_name(name) then return end
        if not action then d.main_menu(name) end

        if action == 'vi' then d.set_visibility(name) end
        if action == 'po' then d.set_position(name) end
        if action == 'co' then d.set_color(name) end
        if action == 'tz' then d.timezone_offset(name) end
        if action == 'in' then d.ingame_time_format(name) end
        if action == 're' then d.real_world_time_format(name) end
        if action == 'ht' then d.host_time_format(name) end
        if action == 'st' then d.session_start_time_format(name) end
        if action == 'sd' then d.session_duration_format(name) end
        if action == 'tf' then d.timer_format(name) end

        if action == 'help' then
            local message = {
                command('vi')..S('Visibility'),
                command('po')..S('Position'),
                command('co')..S('Color'),
                command('tz')..S('Timezone Offset'),
                command('in')..S('Ingame Time Format'),
                command('re')..S('Real-World Time Format'),
                command('ht')..S('Host Time Format'),
                command('st')..S('Session Start Time Format'),
                command('sd')..S('Session Duration Format'),
                command('tf')..S('Timer Format'),
                command('  ')..S('Open Main Menu')
            }
            cs(name, table.concat(message, '\n'))
        end
    end
})
