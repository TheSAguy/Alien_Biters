

function findValidUnit(unitArray)
    for i=1,#unitArray do
        local alien = unitArray[i]
        if (alien ~= nil) and alien.valid then
	    return alien
        end
    end
    return nil -- if it can't find anything

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
