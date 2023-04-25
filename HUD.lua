HUD = {}

local heroScore = 0 
local heroLife = 100 


function HUD.AddScore()
    heroScore = heroScore + 100
end

function HUD.RemoveHeroLife(dt)
end

function HUD.Draw()
    love.graphics.print("Score" .. " " .. tostring(heroScore), 300, 10)
    love.graphics.print("Life" .. " " .. tostring(heroLife), 200, 10)
end

return HUD