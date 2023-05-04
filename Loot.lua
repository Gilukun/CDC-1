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
    for k, v in ipairs(list_tank_E) do
        if v.IsAlive == false then
            love.graphics.rectangle("fill", v.x, v.y, 20, 20)
        end
    end
end

return loot
