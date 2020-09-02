Minetest mod library: poschangelib
==================================
version 0.5

See LICENSE for license information

This lib adds utilities to watch player movements and trigger things when they are
spotted moving.

It does nothing by itself but aim to ease event based upon players or item
moving.

All positions are rounded to node position (integer coordinates).

Summary
  - General warning
  - Watch players' movements
  - Watch players walking on particular nodes
  - Add _on_walk on nodes
  - Set stomping on nodes
  - Add footprints
  - Configuration/Performances tweaking
  - Debugging


General warning
---------------

This mod may be resources consuming. The mods relying upon this lib should use
small functions not to decrease the server performances too much.

The more functions are provided, the more the server can lag (but probably a little
less than running every of them without the lib).



Watch player's movements
------------------------

Use poschangelib.add_player_pos_listener(name, my_callback)

Name is the identifier the listener, to use in remove_player_pos_listener. You should
follow the naming convention like for node names. See http://dev.minetest.net/Intro

The my_callback is a function that takes 4 arguments: the player, last known position,
new position and some metadata.

On first call (once a player joins) the last known position will be nil. If your
listener does something in that case, it will be called shortly after the player
reconnects. It may so be triggered twice from the same position, before leaving and
after joining.

Be aware that the new position may not always be a neighbour of the old one.
When on teleporting, programatic moves with setpos or moving fast it may be far away.

Quick code sample:

local function my_callback(player, old_pos, new_pos, meta)
	if old_pos == nil then
		minetest.chat_send_player(player:get_player_name(), 'Welcome to the world!')
	else
		minetest.chat_send_player(player:get_player_name(),
			"You are now at x:" .. new_pos.x .. ", y:" .. new_pos.y ..
			"z:" .. new_pos.z)
	end
end
poschangelib.add_player_pos_listener("sample:pos_listener", my_callback)



Watch player walking on particular nodes, the rough way
-------------------------------------------------------

Use poschangelib.add_player_walk_listener(name, my_callback, nodenames)

The name is used in the same way as for player position listeners. It aims at reducing
the number of time the stepped node is fetched to share it accross all listeners.

The callback is a function that takes 4 arguments: the player, the position, the node
stepped on and that node description.
See http://dev.minetest.net/minetest.register_node for node description.

You can register the listener for a list of node name or groups, in the same way you
do it to register an ABM. See http://dev.minetest.net/register_abm

For example:
local function flop(player, pos, node, desc)
	minetest.chat_send_player(player:get_player_name(), 'Flop flop')
end
poschangelib.add_player_walk_listener('sample:flop', flop, {'default:dirt_with_grass'})

local function toptop(player, pos, node, desc)
	minetest.chat_send_player(player:get_player_name(), 'Top top top')
end
poschangelib.add_player_walk_listener('sample:top', toptop, {'group:choppy'})



Watch player walking on particular nodes, the fine way
------------------------------------------------------

When dealing with non-filled blocks like slab and snow, the trigger may give some
false positives and be triggered twice for the same movement. This is because you can
hook to a nearby full block and stand above snow without touching it, which messes
with the walk detection of regular blocks (which checks for walkable nodes).

Moreover it can't be enough. With the example of slabs, lower slabs can be triggered
by hanging to a nearby full block and should not be triggered that way, but higher
slabs must be considered like full blocks, because the player is walking on the above
node.

If you don't require an accurate checking, just ignore the call when trigger_meta.redo
is true like in the example below:

local function toptop(player, pos, node, desc, trigger_meta)
	if trigger_meta.redo then return end
	... do your regular stuff
end

If you want to make fine position checking, you can use the 5th argument which holds
the trigger metadata. See "More on metadata" below.



Add _on_walk_over to nodes
-------------------------

This behaviour is ported from the walkover mod only for compatibility.
https://forum.minetest.net/viewtopic.php?f=9&t=15991

A new node property can be added in node definitions:
	_on_walk_over = <function>

This function takes the position, the node and the player as argument.

For compatibility with walkover, you can use on_walk_over (without the underscore
prefix) but it is discouraged as stated in the forum post. This support may be dropped
at any time when most mods have updated the name.

_on_walk is affected by the same issue about non-filled nodes. You can use the 4th
argument to check the trigger metadata to adjust your callback.



More on metadata
----------------

The metadata are a table that can contain the following elements:

interpolated
Is true when the position was assumed and not observed. Most of the time because the
player moved too fast to check all nodes in real time.

teleported
Is true when the player was moving too fast. The interpolation is then not computed.

player_pos
Is set for walk listeners, it contains the player's position. Not set when
interpolated.

source
Contains the name of the node or group that triggered the walk listener.
This is one of thoses passed on registration.

source_level
Contains the level of the group when source is a node group.

redo
Is true when it was detected that the listener was previously called on that position.

covered
Is true when a non-walkable non-air node is present above this node (like grass).
Covered is accurate only with full nodes. For half-filled node, you'll have to check
by hand.



Set stomping on nodes
---------------------

Stomping is a dedicated subset of walk listeners that allows to replace a node by an
other when a player walks on it.

It is required to be able to declare multiple outputs without messing with one
another. And just for ease of use.

Stomping are registered with poschangelib.register_stomp. It takes 3 parameters:

poschangelib.register_stomp:
- source_node_name: the name of the node that can be stomped. It can be a table
    with multiple node names to declare the same stomping behaviour to multiple
    nodes at once.
- stomp_node_name: the name of the replacement node, or a function.
- stomp_desc: stomping parameters.

The stomp description is a table that can contains the following set of keys:

stomp_desc:
- chance: inverted chance that the stomp occurs (default 1)
- duration: time in second after which the stomp reverts.
    When not set, the stomp is forever. If set it will override duration_min and
    duration_max.
- duration_min: same as duration but to add some randomness for each node.
- duration_max: same as duration but to add some randomness for each node.
- priority: the priority rank. The lower, the more important it is (default 100)
- name: name that is used as walk listener name.
    Default is <source>__to__<stomp> and is rather indigest but probably unique.
    It has no default when using a function in stomp_node_name and must be set.
- source_node: set it if you want the stomp to revert to an other node than the
    original.

When multiple stompings are registered for the same node, only the first
triggered is applied. This is when priority comes into play. When a player walks
on a node that can be stomped, a roll is made for each stomp in order of
priority (the lowest priority first). If the roll succeeds, the node is replaced
and the next stomps are not run.

When using a function instead of a stomp node name, this function is a regular
player walk listener. It must return a node or nil (i.e. {name = <name>,
param = <param> etc}). If it returns nil, the stomp is not done and the priority
check is not stopped (see just below). When using only a node name, all other
node values are kept.




Add footprints
--------------

Use poschangelib.register_footprint to quickly register footprinted nodes and
the stomping associated to it. The function takes 2 parameters:

register_footprint:
- node_name: the name of the node to extend, or a table to register multiple
  footprints with the same stomp_desc
- stomp_desc: see above.

The stomp description can have dedicated keys and values:

- footprint_texture: set it to use an other texture than the one embedded.

A new node will be registered with most of it's description copied from the
original node. It's top texture will have the footprint layer on it and the
stomping behaviour will be automatically created.

poschangelib.register_footprint returns the footprinted node name(s). If you
pass nested tables in node_name, the same nesting is returned.



Configuration/Performances tweaking
-----------------------------------

The lib checks for position at a given interval. Default is every 0.3 seconds.

This can be changed by setting poschangelib.check_interval in minetest.conf
or in advanced settings.

Setting a lower value will make the lib more accurate but will be more demanding
on resources (down to 0.05 which is a every server tick).

If the server is lagging, try increasing the interval. If the server can afford
more precise checks you can decrease the value.



Debugging
---------

With the server privileges, you can list available stompings for the node you
are currently on. Use /stomp.

If there is only one stomping available, it is triggered. If there are multiple
stomps, it prints the list of stomping names. Use /stomp X to trigger the Xth
stomp.
