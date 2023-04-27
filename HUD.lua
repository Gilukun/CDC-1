HUD = {}

local heroScore = 0 
local heroLife = 100 


function HUD.AddScore()
    heroScore = heroScore + 100
end

function HUD.RemoveHeroLife(dt)
    if heroLife > 0 then 
     heroLife = heroLife - 10
    end

    if heroLife == 0 then 
        GameState = "GAMEOVER"
        heroLife = 100
    end

end

function HUD.Draw()
    love.graphics.print("Score" .. " " .. tostring(heroScore), 300, 10)
    love.graphics.print("Life" .. " " .. tostring(heroLife), 200, 10)
end

return HUD