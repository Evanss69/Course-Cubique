-- # vim: nowrap
--
-- Set Vim to no-wrapping mode because of some lines not fitting within the 80
-- characters width limit due to overall readability of the code.


-- Localise needed functions
local m = mtimer
local S = m.translator
local build_frame = m.build_frame
local fe = minetest.formspec_escape


-- Real Time Universal Formspec
--
-- This formspec can be used to show formatting options for all real-world time
-- values that can be formatted within mTimer. Since all the real-world times
-- are defined identically this formspec exists so it has to be defined only
-- once and can be re-used as needed.
--
-- @param player_name The name of the player to show the formspec to
-- @config time_type  A time type that is provided by the `get_times` function
-- @return void
-- @see mtimer.get_times
mtimer.dialog.real_time_universal = function (player_name, config)
    local time_data = mtimer.get_times(player_name)[config.time_type]

    mtimer.show_formspec(config.formspec_name, {
        title = config.title,
        show_to = player_name,
        height = 7.5,
        formspec = {
            'field_close_on_enter[format;false]',
            'field[0,0;+linewidth,0.5;format;;'..fe(time_data.format)..']',
            'container[0,0.9]',
            'label[2.8,0;'..S('Variable')..']',
            'label[4.6,0;'..S('Current Value')..']',
            'box[0,0.25;+linewidth,0.02;#ffffff]',
            'label[0,0.5;'..S('Hours (24h)')..']    label[2.8,0.5;{24h}]        label[4.6,0.5;'..time_data.variables.hours_24..']',
            'label[0,0.9;'..S('Hours (12h)')..']    label[2.8,0.9;{12h}]        label[4.6,0.9;'..time_data.variables.hours_12..']',
            'label[0,1.3;'..S('Minutes')..']        label[2.8,1.3;{min}]        label[4.6,1.3;'..time_data.variables.minutes..']',
            'label[0,1.7;'..S('Seconds')..']        label[2.8,1.7;{sec}]        label[4.6,1.7;'..time_data.variables.seconds..']',
            'box[0,1.98;+linewidth,0.02;#ffffff]',
            'label[0,2.2;'..S('Day Name')..']       label[2.8,2.2;{dname}]      label[4.6,2.2;'..time_data.variables.dayname..']',
            'label[0,2.6;'..S('Month Name')..']     label[2.8,2.6;{mname}]      label[4.6,2.6;'..time_data.variables.monthname..']',
            'box[0,2.85;+linewidth,0.02;#ffffff]',
            'label[0,3.1;'..S('Year')..']           label[2.8,3.1;{year}]       label[4.6,3.1;'..time_data.variables.year..']',
            'label[0,3.5;'..S('Month')..']          label[2.8,3.5;{month}]      label[4.6,3.5;'..time_data.variables.month..']',
            'label[0,3.9;'..S('Day')..']            label[2.8,3.9;{day}]        label[4.6,3.9;'..time_data.variables.day..']',
            'box[0,4.2;+linewidth,0.02;#ffffff]',
            'label[0,4.45;'..S('ISO 8601 Date')..'] label[2.8,4.45;{isodate}]   label[4.6,4.45;'..time_data.variables.iso8601_date..']',
            'label[0,4.85;'..S('ISO 8601 Time')..'] label[2.8,4.85;{isotime}]   label[4.6,4.85;'..time_data.variables.iso8601_time..']',
            'label[0,5.25;'..S('Timestamp')..']     label[2.8,5.25;{timestamp}] label[4.6,5.25;'..time_data.variables.timestamp..']',
            'box[0,5.55;+linewidth,0.02;#ffffff]',
            'label[0,5.8;'..S('Current Result')..']',
            'label[2.8,5.8;'..fe(time_data.formatted)..']',
            'container_end[]'
        }
    })
end

