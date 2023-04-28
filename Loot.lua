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
    love.graphics.print(tostring(missile))
    --love.graphics.print(tostring(hasMissile), 100, 100)
end

return loot