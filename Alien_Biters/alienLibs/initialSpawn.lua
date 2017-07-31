---- Initial Spawn of Alien Units. 
---- Able to set how many crash landed via Settings.


-- Veden Note:
-- anytime you have lots of constant getting repeating in files they should be all pulled into a single file
-- and have modules built from them to centralize there management. Below is a small demo for doing modules.

-- this is a file called file1.lua and is the module we are defining for use in file2.lua
--[[
--------------
file1.lua
local constants = {} -- this is a table that this file will build to be returned for use in the require("<library>") in file2.lua

local function b(x) -- this wont be accessible from outside of this file
   return x + 3
end

function constants.a(x) -- notice the name has a prefix of the table we defined at the start, this will be a something you can call outside of this file
    return x + 1
end

return constants -- return the table we built up as the last statement in the file1.lua

--------------
file2.lua
local constants = require("file1") -- here we are grabbing file1.lua and the thing that is returned is the constants table we created in file1.lua

constants.a(2) => 3 -- this is how you would call the function we declared in file1.lua
constants.b(3) => error -- this is will not work
--]]

--- Water tiles in game
local waterTiles =
{
  ["deepwater"] = true,
  ["deepwater-green"] = true,
  ["water"] = true,
  ["water-green"] = true
}



function Initial_Spawn(surface)

	local spawn_zone = 100
	local Nest_Spawned = 0
	local Scatter = 0
	local chart_radius = 10
	local radius_from_player = settings.startup["Alien_Distance"].value
	
	--for i = 1, settings.startup["Alien_Count"].value do 
	while Nest_Spawned < settings.startup["Alien_Count"].value do
		
		local surface = surface
		local pos_x = math.random(-(spawn_zone+Scatter),(spawn_zone+Scatter))
		local pos_y = math.random(-(spawn_zone+Scatter),(spawn_zone+Scatter))
		
		if pos_x < 0 then 
			pos_x = pos_x - radius_from_player
		else
			pos_x = pos_x + radius_from_player
		end
		if pos_y < 0 then 
			pos_y = pos_y - radius_from_player
		else
			pos_y = pos_y + radius_from_player
		end

		
		
		--local currentTilename = game.surfaces[1].get_tile(pos_x,pos_y).name
		
		-- Still having an issue here, Aliens are still spwaning in water tiles. Thought 
		-- I'd fix this issue by looking if the tile was a water tile and then preventing the spawn, 
		-- but could not get "get_tile" to work
		
		if surface.can_place_entity({ name="alien-army-26", position={pos_x, pos_y}, force = game.forces.alien}) then --and not waterTiles[currentTilename] then
					
			local lords = surface.create_entity({name="alien-army-26", position={pos_x, pos_y},force = game.forces.alien})	
			--global.Initial_Aliens[i] = lords
			
			Nest_Spawned = Nest_Spawned + 1
			--global.Initial_Aliens[i] = lords
			global.Initial_Aliens.count[Nest_Spawned] = lords -- I keep track of the initial units spawned, since I want to give them orders in the beginning of the game.
			-- I could propably use "lords" instead of keeping track of it by itself...
		
			-- QC to look at spawned units.
			--[[
			--Reveal spawned unit
			for _,force in pairs( game.forces )do
				force.chart( surface, {{x = pos_x - chart_radius, y = pos_y - chart_radius}, {x = pos_x, y = pos_y}})
			end			
			]]
			
			
			Scatter = Scatter + 100
		else 
		
			Nest_Spawned = Nest_Spawned
			
		end
		
	end

	
    return lords
end


---------- Test Stuff  ----------------

function tester2(surface)
   

   for i = 1, 100 do
    
	--global.Alien.Horde[i] = surface.create_entity({name="alien-army-"..i, position={i, 5},force = game.forces.alien})
	
			

		local Alien_Spawn_Position = surface.find_non_colliding_position("alien-army-"..i, {i, 5}, 1 , 0.5)
		if Alien_Spawn_Position then
			local lords = surface.create_entity({name="alien-army-"..i, position=Alien_Spawn_Position,force = game.forces.alien})
		else
			local lords = surface.create_entity({name="alien-army-"..i, position={i, 7},force = game.forces.alien})
		end

	end	
		--[[		
    local lord = surface.create_entity({name="alien-army-25",
                                                 position={19, 19},
                                                 force = game.forces.alien})
												 --end
     for i = 1, 100 do
         surface.create_entity({name="alien-army-" .. i,
                                         position={math.random(-50, 50), math.random(-50, 50)},
                                         force = game.forces.alien})
     end
	 
	      for i = 1, 20 do
         surface.create_entity({name="small-alien",
                                         position={math.random(20, 350), math.random(20, 350)},
                                         force = game.forces.alien})
     end
	 
]]	 
	surface.create_entity({name="biter-spawner", position={25, 25},force = game.forces.enemy})
	surface.create_entity({name="biter-spawner", position={30, 30},force = game.forces.enemy})
	surface.create_entity({name="biter-spawner", position={35, 35},force = game.forces.enemy})
	surface.create_entity({name="biter-spawner", position={40, 40},force = game.forces.enemy})
	for i = 1, 100 do
		surface.create_entity({name="big-biter", position={i+40, 40},force = game.forces.enemy})
	end
	
    return lords
end
