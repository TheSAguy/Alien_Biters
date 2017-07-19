require "util"
require "alienLibs/initialSpawn"
require "alienLibs/logic"


if remote.interfaces.EvoGUI then
	require "alienLibs/EvoGUI"
end



local QC_Mod = true



local waterTiles =
{
  ["deepwater"] = true,
  ["deepwater-green"] = true,
  ["water"] = true,
  ["water-green"] = true,
  ["out-of-map"] = true
}


---------------------------------------------				 
function on_initialize()
	
	local surface = game.surfaces['nauvis']
	
	if game.forces['alien'] == nil then
        game.create_force('alien')
		game.forces['alien'].ai_controllable = true	
	end
		if global.Alien == nil then
			global.Alien = {}		
	
			global.Alien.freeAliens = {}
			global.Alien.minions = {}
			global.Alien.clans = {}
			global.Alien.den = {}
		
		end
			
		if global.Alien.lords == nil then
			global.Alien.lords = {}
		end
		
		
		---- Used for EvoGUI
		if not global.Total_Nest_Count then
			global.Total_Nest_Count = 0
        elseif global.Total_Nest_Count < 0 then
			global.Total_Nest_Count = 0
		end

		if global.Initial_Aliens == nil then
			global.Initial_Aliens  = {}
			global.Initial_Aliens.count = {} 
		end

		global.Alien.lords = Initial_Spawn(surface)
		

		--global.Alien.lords = tester2(surface)
		
		
end



local function On_Death(event)

	surface = event.entity.surface
    global.Alien = raisealien(event, global.Alien, surface)
	
end


local counter = 0
Event.register(defines.events.on_tick, function(event)	

	
    if (event.tick % 440 == 0) then
		
		
		
		if counter < 10 then
		
			local chart_radius = 10
			local counts = global.Initial_Aliens.count
			local InitialIndex = 1
			local radius = 10
			local pos = global.Initial_Aliens.count.positions
			
			repeat
				
				local count = counts[InitialIndex]		
				local target = nil
					
				if (count ~= nil) and (count.valid) then
					local surface = count.surface			
					local pos = count.position
					local currentTilename = surface.get_tile(pos.x,pos.y).name
				
					
					writeDebug(currentTilename)
					
					--if waterTiles[currentTilename] then
					--	count.destroy()
					--end

					for _,force in pairs( game.forces )do
						force.chart( surface, {{x = count.position.x - chart_radius, y = count.position.y - chart_radius}, {x = count.position.x, y = count.position.y}})
					end	
					
					local radius = radius + (20 * game.forces.enemy.evolution_factor)
					local area = {{pos.x - radius, pos.y - radius}, {pos.x + radius, pos.y + radius}}
					local spawner = surface.find_entities_filtered({area = area, type = "unit-spawner", force= "enemy"})
					
					if #spawner > 0 and not waterTiles[currentTilename] then
					writeDebug("Found a Spawner to attack")
						
						for _,enemy in pairs(spawner) do
							if target == nil then
								target={enemy}
							end
						end
					
					end			
					if (target ~= nil) and (count ~= nil) and (count.valid) then
						
						count.set_command({type = defines.command.attack, target = target[1]})
						
					else
						count.set_command({type = defines.command.wander})
						radius = radius + 2
					end
				
				
				else
					writeDebug("found invalid one")
				end
				
			
				InitialIndex = InitialIndex + 1
			until (InitialIndex >= #counts)
		
			--[[
			
			for i = 1, #global.Initial_Aliens.count do
			writeDebug(global.Initial_Aliens.count)
			
			
				if global.Initial_Aliens.count.valid and global.Initial_Aliens ~= nil then
				writeDebug("Was Valid")
				global.Initial_Aliens.count.set_autonomous()
				
				end
				
				local surface = game.surfaces['nauvis']
				for _,force in pairs( game.forces )do
					force.chart( surface, {{x = global.Initial_Aliens.position.x - chart_radius, y = global.Initial_Aliens.position.y - chart_radius}, {x = global.Initial_Aliens.position.x, y = global.Initial_Aliens.position.y}})
				end		
				
				
				--global.Initial_Aliens.set_command(defines.command.wander)
				
				end
			
			end 
			]]
			counter = counter + 1
		end	
    end
end)






---------------------------------------------
script.on_init(on_initialize)

--script.on_event(defines.events.on_entity_died, on_remove)

local death_events = {defines.events.on_entity_died}
script.on_event(death_events, On_Death)





--------------------------------------------------------------------
function writeDebug(message)
	if QC_Mod == true then 
		for i, player in pairs(game.players) do
			player.print(tostring(message))
		end
	end
end
