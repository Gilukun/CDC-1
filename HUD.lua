HUD = {}

local Player_Score = 0 
local Player_LifeInit = 100 
local Player_life = Player_LifeInit
local AddScore = 100 
local RemoveLife = 10

local Player_lifeContour = {}
Player_lifeContour.x = 10
Player_lifeContour.y = 10
Player_lifeContour.Width = 200
Player_lifeContour.Height = 10

local Player_lifeInlay ={}
Player_lifeInlay.x = 10
Player_lifeInlay.y = 10
Player_lifeInlay.Width = 200
Player_lifeInlay.Height = 10

local ShieldActive = {}
ShieldActive.x = 10
ShieldActive.y = 22
ShieldActive.Width = 100
ShieldActive.Height = 10
ShieldActiveWidth = ShieldActive.Width

local EMIActive= {}
EMIActive.x = 10
EMIActive.y = 44
EMIActive.Width = 100
EMIActive.Height = 10

local ratio = 0.01


function HUD.AddScore()
    Player_Score = Player_Score + AddScore
end

function HUD.RemoveHeroLife(dt)
    if Player_life > 0 then 
        Player_life = Player_life - RemoveLife
        Player_lifeInlay.Width = math.ceil(Player_lifeInlay.Width * (Player_life * ratio))
    end

    if Player_life == 0 then 
        G_State = GameState.GameOver
        Player_life = Player_LifeInit
    end
end

function HUD.Draw()
    love.graphics.setColor(love.math.colorFromBytes(255, 18, 0))
    love.graphics.rectangle("fill", Player_lifeInlay.x, Player_lifeInlay.y, Player_lifeInlay.Width, Player_lifeInlay.Height)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", Player_lifeContour.x, Player_lifeContour.y, Player_lifeContour.Width, Player_lifeContour.Height)

    if Shield_ON == true then 
        
        love.graphics.setColor(love.math.colorFromBytes(27, 175, 173))
        love.graphics.scale(Shield_Timer, 1)
        love.graphics.rectangle("fill", ShieldActive.x, ShieldActive.y, ShieldActiveWidth, ShieldActive.Height)
        love.graphics.setColor(1,1,1)
    end

    if EMI_ON == true then 
        love.graphics.scale(EMI_Timer, 1)
        love.graphics.setColor(love.math.colorFromBytes(27, 255, 173))
        love.graphics.rectangle("fill", EMIActive.x, EMIActive.y, EMIActive.Width, EMIActive.Height)
        love.graphics.setColor(1,1,1)
    end
end

return HUD