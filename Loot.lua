Loot = {}

missile = 0

list_TypeLoot = {}
list_TypeLoot.AddLifeSmall = "LIFE+"
list_TypeLoot.AddLifeSmall = "LIFE++"
list_TypeLoot.Shiel = "SHIELD"
list_TypeLoot.IEM = "LIFE++"

PrisonerSpawn = {}
function CreerSpawn()
    PrisonerSpawn[1] = {
        x = 300,
        y = 100
    }
    PrisonerSpawn[2] = {
        x = 100,
        y = 500
    }
    PrisonerSpawn[3] = {
        x = 700,
        y = 900
    }
    PrisonerSpawn[4] = {
        x = 900,
        y = 250
    }
    PrisonerSpawn[5] = {
        x = 500,
        y = 550
    }
end

function Loot.Start()
    list_Loot = {}
    function Loot.CreerLoot(pNom, pX, pY)
        local loot = {}
        loot.nom = pNom
        loot.x = pX
        loot.y = pY
        table.insert(list_Loot, loot)
    end
    CreerSpawn()
end

prisoner = {}
prisoner.frames = {}
prisoner.frame = 1
prisoner.image = nil
prisoner.x = 0
prisoner.y = 0
prisoner.saved = false

function Loot.Load()
    Img_LootS = love.graphics.newImage("Images/Loot_S.png")
    Img_LootL = love.graphics.newImage("Images/Loot_L.png")
    Img_LootShield = love.graphics.newImage("Images/Loot_Shield.png")

    prisoner.image = love.graphics.newImage("Images/Prisoner.png")
    prisoner.frames[1] = love.graphics.newQuad(0, 0, 25, 31, prisoner.image:getWidth(), prisoner.image:getHeight())
    prisoner.frames[2] = love.graphics.newQuad(25, 0, 25, 31, prisoner.image:getWidth(), prisoner.image:getHeight())
end

function Loot.Update(dt)
    prisoner.frame = prisoner.frame + 2 * dt
    if prisoner.frame >= #prisoner.frames + 1 then
        prisoner.frame = 1
    end
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

    for z = #PrisonerSpawn, 1, -1 do
        local spwan = PrisonerSpawn[z]
        local frameArrondie = math.floor(prisoner.frame)
        love.graphics.draw(prisoner.image, prisoner.frames[frameArrondie], spwan.x, spwan.y)
        love.graphics.draw(prisoner.image, prisoner.frames[frameArrondie], spwan.x, spwan.y)
        love.graphics.draw(prisoner.image, prisoner.frames[frameArrondie], spwan.x, spwan.y)
        love.graphics.draw(prisoner.image, prisoner.frames[frameArrondie], spwan.x, spwan.y)
        love.graphics.draw(prisoner.image, prisoner.frames[frameArrondie], spwan.x, spwan.y)
    end
end

return Loot
