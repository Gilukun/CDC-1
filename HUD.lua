HUD = {}

local tankHeroScore = 0 

function HUD.AddScore()
    tankHeroScore = tankHeroScore + 100
end

function HUD.Draw()
    love.graphics.print(tostring(tankHeroScore), 300, 300)
end

return HUD