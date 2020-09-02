local m = mtimer
local S = m.translator


-- Get translated date names
--
-- This helper function takes a table containing a numerical month and a
-- numerical day of the week and returns the respecive names that are ready
-- for being translated.
--
--   { day = 1, month = 6 }   ->   { day = S('Monday'), month = S('May') }
--
-- @param dates A table of dates as described
-- @return table The table containing the date names
local get_date_names = function (dates)
    -- %w -> weekday [0-6 = Sunday-Saturday]
    local weekdays = {
        S('Sunday'), S('Monday'), S('Tuesday'), S('Wednesday'), S('Thursday'),
        S('Friday'), S('Saturday')
    }
    -- %m -> month [01-12 = January-December]
    local months = {
        S('January'), S('February'), S('March'), S('April'), S('May'),
        S('June'), S('July'), S('August'), S('September'), S('Oktober'),
        S('November'), S('December')
    }
    return {
        day = weekdays[tonumber(dates.day+1)],
        month = months[tonumber(dates.month)]
    }
end


-- Real-world time handling
--
-- This function returns the formatted string as well as the raw format string
-- and all the replacement values for the variables basing on what time type
-- was requested. The types are `real` for the real-world time or `session`
-- for the session start time.
--
-- Both of the times use the same syntax and have the same variables to set so
-- one function is used for both when getting the times with `mtimer.get_times`
-- where needed.
--
--   {
--     times = {
--       server_time = ISO 8601 date of the server’s timestamp,
--       server_local = ISO 8601 date of the local ofsetted timestamp,
--       offset = timezone offset as set by the player
--     },
--     variables = {
--       hours_24 = 24h representation of the time,
--       hours_12 = 12h representation of the time,
--       minutes = minutes for the requested time,
--       seconds = seconds for the requested time,
--       dayname = name of the day for the requested time,
--       monthname = name of the month for the requested time,
--       year = year of the requested time,
--       month = month of the requested time,
--       day = day of the requested time,
--       iso8601_date = ISO 8601 date part based on the requested time,
--       iso8601_time = ISO 8601 time part based on the requested time,
--       timestamp = the date’s timestamp
--     },
--     format = raw string for formatting the requeste time type,
--     formatted = the formatted (all variables replaced) string
--   }
--
-- @param player_name The name of the player to get the times for
-- @param time_type   A Time type as described
-- @return table      The table containing the data as described
local get_real_time_universal = function (player_name, time_type)
    local player = minetest.get_player_by_name(player_name)
    local player_meta = player:get_meta()
    local m_meta = m.meta
    local timezone_offset = player_meta:get_string(m_meta.timezone_offset.key)
    local server_timestamp = ''
    local local_timestamp = ''
    local format = ''
    local force_utc = '!'

    if time_type == 'real' then
        server_timestamp = os.time()
        local_timestamp = server_timestamp + ((timezone_offset*60)*60)
        format = player_meta:get_string(m_meta.real_time.key)
    elseif time_type == 'session' then
        server_timestamp = player_meta:get('mtimer:session_start')
        local_timestamp = server_timestamp + ((timezone_offset*60)*60)
        format = player_meta:get_string(m_meta.session_start_time.key)
    elseif time_type == 'host' then
        server_timestamp = os.time()
        local_timestamp = server_timestamp
        format = player_meta:get_string(m_meta.host_time.key)
        force_utc = ''
    end

    local date_names = get_date_names({
        day = os.date('!%w', local_timestamp),
        month = os.date('!%m', local_timestamp)
    })

    local values = {
        times = {
            server_time = os.date('%Y-%m-%dT%H:%M:%S', server_timestamp),
            local_time = os.date('!%Y-%m-%dT%H:%M:%S', local_timestamp),
            offset = timezone_offset,
        },
        variables = {
            hours_24 = os.date(force_utc..'%H', local_timestamp),
            hours_12 = os.date(force_utc..'%I', local_timestamp),
            minutes = os.date(force_utc..'%M', local_timestamp),
            seconds = os.date(force_utc..'%S', local_timestamp),
            dayname = date_names.day,
            monthname = date_names.month,
            year = os.date(force_utc..'%Y', local_timestamp),
            month = os.date(force_utc..'%m', local_timestamp),
            day = os.date(force_utc..'%d', local_timestamp),
            iso8601_date = os.date(force_utc..'%Y-%m-%d', local_timestamp),
            iso8601_time = os.date(force_utc..'%H:%M:%S', local_timestamp),
            timestamp = local_timestamp
        },
        format = format
    }

    values['formatted'] = format:gsub('{[a-z0-9]+}', {
        ['{24h}'] = values.variables.hours_24,
        ['{12h}'] = values.variables.hours_12,
        ['{min}'] = values.variables.minutes,
        ['{sec}'] = values.variables.seconds,
        ['{dname}'] = values.variables.dayname,
        ['{mname}'] = values.variables.monthname,
        ['{year}'] = values.variables.year,
        ['{month}'] = values.variables.month,
        ['{day}'] = values.variables.day,
        ['{isodate}'] = values.variables.iso8601_date,
        ['{isotime}'] = values.variables.iso8601_time,
        ['{timestamp}'] = values.variables.timestamp
    })

    return values
end


-- Getting the ingame time
--
-- This function gets and parses the ingame time based on the configuration set
-- by the player. The following table is returned.
--
-- {
--   hours_24 =  24h representation of the time,
--   hours_12 = 12h representation of the time,
--   minutes = minutes for the requested time,
--   ingame_timestamp = timestamp of the ingame time (seconds since 0),
--   format = raw string for formatting the time,
--   formatted = the formatted (all variables replaced) string
-- }
--
-- Calculation: The function `minetest.get_timeofday()` returns a fraction
--              between 0 and 1 for the time of the day. Multiplication with
--              24000 converts this number to a millihours value (mh). By
--              multiplication with 3.6 the mh value is converted into a
--              seconds value that can be used as timestamp.
--
-- Usabiliy: After 86400 seconds (or 24000 mh) the timestamp returns to 0 and
--           thus is only useful to represent the time of the day and nothing
--           else like the date or something like that.
--
-- The generated timestamp is then passed to the os.date() default Lua function
-- to parse the human-readable interpretations. Technically this is our own
-- epoch timestamp just being reset after 86400 seconds.
--
-- @param player_name The name of the player to get the time for
-- @return table The table as described
local get_ingame_time = function (player_name)
    local player = minetest.get_player_by_name(player_name)
    local format = player:get_meta():get_string(m.meta.ingame_time.key)
    local time_of_day = tostring((minetest.get_timeofday() * 24000) * 3.6)
    local ingame_timestamp = tonumber(string.format('%.0f', time_of_day))

    local values = {
        hours_24 = os.date('!%H', ingame_timestamp),
        hours_12 = os.date('!%I', ingame_timestamp),
        minutes = os.date('!%M', ingame_timestamp),
        ingame_timestamp = ingame_timestamp,
        format = format
    }

    values['formatted'] = format:gsub('{[a-z0-9]+}', {
        ['{24h}'] = values.hours_24,
        ['{12h}'] = values.hours_12,
        ['{min}'] = values.minutes,
        ['{its}'] = values.ingame_timestamp
    })

    return values
end


-- Getting the session duration
--
-- This function gets the session start timestamp and the current timestamp and
-- calculates the difference in days, hours, minutes, and seconds. The values
-- are added to the return table as shown below. Additionaly the format string
-- and the formatted result string are added to this table
--
-- {
--   format = raw string for formatting the time,
--   difference = the raw difference in seconds,
--   days = days the difference is long,
--   hours = hours the difference is long,
--   minutes = minutes the difference is long,
--   seconds = seconds the difference is long,
--   formatted = the formatted (all variables replaced) string
-- }
--
-- @param player_name The name of the player to get the duration for
-- @return table The table as described
local get_session_duration = function (player_name)
    local player = minetest.get_player_by_name(player_name)
    local player_meta = player:get_meta()
    local format = player_meta:get_string(m.meta.session_duration.key)
    local start_timestamp = player_meta:get_string('mtimer:session_start')
    local current_timestamp = os.time()
    local difference = current_timestamp - start_timestamp

    local values = {
        format = format,
        difference = difference,
        days = string.format('%02d', math.floor(difference/86400)),
        hours = string.format('%02d', math.floor((difference % 86400)/3600)),
        minutes = string.format('%02d', math.floor((difference % 3600)/60)),
        seconds = string.format('%02d', math.floor((difference % 60)))
    }

    values['formatted'] = format:gsub('{[a-z0-9]+}', {
        ['{days}'] = values.days,
        ['{hours}'] = values.hours,
        ['{minutes}'] = values.minutes,
        ['{seconds}'] = values.seconds
    })

    return values
end


-- Get the times
--
-- Returns the times for the given player referenced by the player’s name as
-- a table as shown below.
--
-- {
--   session_start_time = @see get_real_time_universal,
--   session_duration = @see get_session_duration,
--   real_time = @see get_real_time_universal,
--   ingame_time = @see get_ingame_time
-- }
--
-- @param player_name The name of the player to get the times for
-- @return table The table containing the times as described
mtimer.get_times = function (player_name)
    return {
        ingame_time = get_ingame_time(player_name),
        real_time = get_real_time_universal(player_name, 'real'),
        host_time = get_real_time_universal(player_name, 'host'),
        session_start_time = get_real_time_universal(player_name, 'session'),
        session_duration = get_session_duration(player_name)
    }
end
