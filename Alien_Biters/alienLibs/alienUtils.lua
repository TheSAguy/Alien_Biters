
-- Veden Note
-- Why are you deleting items from the array as you look for units?
function killAlien(unitArray)
	--writeDebug(unitArray)
    if unitArray ~= nil then
		for i=1, #unitArray do
			local alien = unitArray[i]
			if (alien.valid) then
				alien.die()
			end
			unitArray[i] = nil
		end
	end
end


-- Veden Note
-- the while loop can be replaced with a return statement
function findValidUnit(unitArray)
    for i=1,#unitArray do
        local alien = unitArray[i]
        if (alien ~= nil) and alien.valid then
	    return alien
        end
    end
    return nil -- if it can't find anything

    -- local unit = nil
    -- local i = 1
    -- while (i < #unitArray) and (unit == nil) do
    --     local alien = unitArray[i]
    --     if (alien ~= nil) then
    --         if (alien.valid) then
    --             unit = alien
    --         else
    --             unitArray[i] = nil
    --         end
    --     end
    --     i = i + 1
    -- end
    -- return unit
end

function euclideanDistance(p1, p2)
    local xs = p1.x - p2.x
    local ys = p1.y - p2.y
    return ((xs * xs) + (ys * ys)) ^ 0.5
end

function boundingBox(p, radius)
    return {{p.x - radius, p.y - radius},
            {p.x + radius, p.y + radius}}
end
