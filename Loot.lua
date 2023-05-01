loot = {}

missile = 0
hasMissile = false

function loot.DropLoot()
    hasMissile = true
    missile = missile + 10 
    if missile >= 20 then 
        missile = 20 
    end
end

function loot.Draw()
end

return loot