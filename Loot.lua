Loot = {}

missile = 0

list_TypeLoot = {}
list_TypeLoot.AddLifeSmall = "LIFE+"
list_TypeLoot.AddLifeSmall = "LIFE++"
list_TypeLoot.Shiel = "SHIELD"
list_TypeLoot.IEM = "LIFE++"

list_Loot = {}
function Loot.CreerLoot(pNom, pX, pY)
    local loot = {}
    loot.nom = pNom
    loot.x = pX
    loot.y = pY
    table.insert(list_Loot, loot)
end

function Loot.Load()
    Img_LootS = love.graphics.newImage("Images/Loot_S.png")
    Img_LootL = love.graphics.newImage("Images/Loot_L.png")
    Img_LootShield = love.graphics.newImage("Images/Loot_Shield.png")
end

function Loot.Draw()
    for k, v in ipairs(list_Loot) do
        if v.nom == "SMALL" then
            love.graphics.draw(Img_LootS, v.x, v.y)
        end
        if v.nom == "BIG" then
            love.graphics.draw(Img_LootL, v.x, v.y)
        end

        if v.nom == "SHIELD" then
            love.graphics.draw(Img_LootShield, v.x, v.y)
        end
    end
end

return Loot
