local m = mtimer
local S = m.translator


-- Build the formspec frame
--
-- This function builds and displays a formspec based on the input.
--
-- The `name` is the usual formspec name (for example `mymod:my_formspec`) and
-- has to be provided as a simple string all other parameters are provided via
-- the `def` table. The following table is an example.
--
-- {
--   title = 'Nice Title'    -- Automatically prefixed for orientation
--   prefix = '[Blarb] '     -- Optional title prefix
--   width = 8,              -- Optional width of the content container
--   height = 3,             -- Optional height of the content container
--   show_to = 'Playername'  -- Name of the player to show the formspec to
--   add_buttons = false     -- Optionally hide buttons
--   content_offset = 0      -- Optionally Offset content height position
--   formspec = {}           -- Table with formspec definition
-- }
--
-- When set the title is prefixed with the prefix value. If omitted “[mTimer] ”
-- is used. The example creates “[Blarb] Nice Title” as title. Translated
-- strings can be used here. The Title and prefix are “formspec-safe” so
-- strings that are formspec elements can be used to show them literal.
--
-- The default buttons can be hidden by adding `add_buttons = false` to the
-- definition table. If omitted the buttons are shown. When not shown the
-- formspec size will be reduced by the amout of units the buttons would
-- have taken place.
--
-- Some formspec elements do nbot properly start at 0,0 even if set so. The
-- `content_offset` attribute offsets the content vertically by the given
-- amount of units. Formspec height and button positions are fixed according
-- to the given value.
--
-- The table entries for `formspec` are the usual formspec elements that
-- define what a formspec looks like. You can write all definition in one entry
-- or split the definition into multiple entries.
--
-- The definition defines the CONTENT of the formspec not the whole formspec so
-- you can easily start at 0,0 for your definition. The function automatically
-- places everything in relation to the formspec frame and default buttons.
--
-- The minimum formspec width and height are 8 units in width and 3 units in
-- height. So `width` and `height` can be omitted when all of your content fits
-- into the default size. The resulting formspec is a minimum of 8 units wide
-- and 4.6 units high (1.6 units are added for the title and the buttons).
--
-- All formspec table entries can contain the following variables. Variables
-- start with a plus sign (+) and are read until any character that is not
-- a letter. Some variables are useless, some can be used quite well.
--
--   Variable Name    Value Type
--  --------------------------------------------------------------------------
--   +width           width of the formspec
--   +height          height of the formspec
--   +linewidth       optimal width for a box that is used as horizontal line
--   +title           formspec’s title
--   +content         content container vertical position (+offset)
--   +buttons         default buttons vertical position
--   +defbutton       “Default” button’s horizontal position
--   +mainbutton      “Main Menu” button’s horizontal position
--   +exitbutton      “Exit” button’s horizontal position
--
-- @param name The name of the formspec
-- @param def  The definition table as described
-- @return string the constructed “frame”
mtimer.show_formspec = function (name, def)
    local add_buttons = def.add_buttons == true or def.add_buttons == nil
    local content_offset = def.content_offset or 0
    local width = (def.width or 0) <= 8 and 8 or def.width
    local height = (def.height or 0) <= 3 and 4.6 or def.height + 1.6
    local prefix = def.prefix or '[mTimer] '
    if not add_buttons then height = height - 1.6 end

    height = height + content_offset

    local buttons = not add_buttons and '' or table.concat({
        'container[0,+buttons]',
        'box[0.25,0;+linewidth,0.04;#ffffff]',
        'button[+defbutton,0.2;2,0.5;default;'..S('Default')..']',
        'button[+mainbutton,0.2;2,0.5;main_menu;'..S('Main Menu')..']',
        'button_exit[+exitbutton,0.2;2,0.5;exit;'..S('Exit')..']',
        'container_end[]'
    }, ' ')

    local formspec = table.concat({
        'formspec_version[2]',
        'size[+width,+height]',
        'image[0.25,0.2;0.3,0.3;+icon]',
        'label[0.65,0.35;+title]',
        'box[0.25,0.6;+linewidth,0.04;#ffffff]',
        'container[0.25,+content]',
        table.concat(def.formspec, ' '),
        'container_end[]',
        buttons
    }, ' ')

    formspec = formspec:gsub('%+%a+', {
        ['+width'] = width+0.25,
        ['+height'] = height,
        ['+linewidth'] = width-0.25,
        ['+title'] = minetest.formspec_escape(prefix..def.title),
        ['+icon'] = 'mtimer_icon_'..name:gsub('mtimer:', '')..'.png',
        ['+content'] = 0.9 + content_offset,
        ['+buttons'] = height-1,
        ['+defbutton'] = 0.25,
        ['+mainbutton'] = width-4.4+0.25,
        ['+exitbutton'] = width-2.25+0.25,

    })

    minetest.show_formspec(def.show_to, name, formspec)
end
