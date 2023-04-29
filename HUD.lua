HUD = {}

local heroScore = 0 
local heroLifeInit = 100 
local heroLife = heroLifeInit
local AddScore = 100 
local RemoveLife = 10

local HLContour = {}
HLContour.x = 10
HLContour.y = 10
HLContour.Width = 200
HLContour.Height = 10

local HLInlay ={}
HLInlay.x = 10
HLInlay.y = 10
HLInlay.Width = 200
HLInlay.Height = 10

local ShieldActive = {}
ShieldActive.x = 10
ShieldActive.y = 22
ShieldActive.Width = 100
ShieldActive.Height = 20
ShieldActiveWidth = ShieldActive.Width

local EMIActive= {}
EMIActive.x = 10
EMIActive.y = 44
EMIActive.Width = 100
EMIActive.Height = 10
EMIActiveWidth = EMIActive.Width

local ratio = 0.01


function HUD.AddScore()
    heroScore = heroScore + AddScore
end

function HUD.RemoveHeroLife(dt)
    if heroLife > 0 then 
        heroLife = heroLife - RemoveLife
        HLInlay.Width = math.ceil(HLInlay.Width * (heroLife * ratio))
    end

    if heroLife == 0 then 
        G_State = GameState.GameOver
        heroLife = heroLifeInit
    end
end

function HUD.Updates(dt)
    if EMI_ON == true then 
        if EMIActiveWidth >= 0 then 
            EMIActiveWidth = math.ceil(EMIActiveWidth - (EMI_Timer * 1/ratio * dt ))
        end
        if EMIActiveWidth <= 0 then 
            EMIActiveWidth = EMIActive.Width
        end
    end

    if Shield_ON == true then 
        if ShieldActiveWidth >= 0 then 
            ShieldActiveWidth = math.ceil(ShieldActiveWidth - (Shield_Timer * 1/ratio * dt))
        end
        if ShieldActiveWidth <= 0 then 
            ShieldActiveWidth = ShieldActive.Width
        end
    end
end

function HUD.Draw()
    love.graphics.print("Score" .. " " .. tostring(HLInlay.Width), 300, 10)
    love.graphics.setColor(love.math.colorFromBytes(255, 18, 0))
    love.graphics.rectangle("fill", HLInlay.x, HLInlay.y, HLInlay.Width, HLInlay.Height)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", HLContour.x, HLContour.y, HLContour.Width, HLContour.Height)

    if Shield_ON == true then 
        love.graphics.setColor(love.math.colorFromBytes(27, 175, 173))
        love.graphics.rectangle("fill", ShieldActive.x, ShieldActive.y, ShieldActiveWidth, ShieldActive.Height)
        love.graphics.setColor(1,1,1)
    end

    if EMI_ON == true then 
        love.graphics.setColor(love.math.colorFromBytes(27, 175, 173))
        love.graphics.rectangle("fill", EMIActive.x, EMIActive.y, EMIActiveWidth, EMIActive.Height)
        love.graphics.setColor(1,1,1)
        love.graphics.print("Score" .. " " .. tostring(EMIActiveWidth), 400, 10)
    end
    
end

return HUD