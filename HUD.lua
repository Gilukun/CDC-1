HUD = {}

local Player_Score = 0 
local Player_LifeInit = 100 
local Player_life = Player_LifeInit
local AddScore = 100 
local RemoveLife = 10

local Player_lifeContour = {}
Player_lifeContour.x = 10
Player_lifeContour.y = 10
Player_lifeContour.Width = 300
Player_lifeContour.Height = 10

local Player_lifeInlay ={}
Player_lifeInlay.x = 10
Player_lifeInlay.y = 10
Player_lifeInlay.Width = 300
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


function HUD.AddScore()
    Player_Score = Player_Score + AddScore
end

function HUD.AddLife()
    if Player_life < Player_LifeInit then 
        Player_life = Player_life + 5
    end
end

function HUD.RemoveHeroLife(dt)
    if Player_life > 0 then 
        Player_life = Player_life - RemoveLife
    end

    if Player_life == 0 then 
        G_State = GameState.GameOver
        Player_life = Player_LifeInit
    end
end



function HUD.Draw()
    local ratio_Life =  Player_life / Player_LifeInit
    love.graphics.setColor(love.math.colorFromBytes(255, 18, 0))
    love.graphics.rectangle("fill", Player_lifeInlay.x, Player_lifeInlay.y, Player_lifeInlay.Width * ratio_Life, Player_lifeInlay.Height)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", Player_lifeContour.x, Player_lifeContour.y, Player_lifeContour.Width, Player_lifeContour.Height)

    if Shield_ON == true then 
        local ratio_Bouclier = Shield_Timer / Shield_Duration
        love.graphics.setColor(love.math.colorFromBytes(27, 175, 173))
        love.graphics.rectangle("fill", ShieldActive.x, ShieldActive.y, ShieldActiveWidth * ratio_Bouclier, ShieldActive.Height)
        love.graphics.setColor(1,1,1)
    end

    if EMI_ON == true then 
        local ratio_EMI = EMI_Timer / EMI_Duration
        love.graphics.setColor(love.math.colorFromBytes(27, 255, 173))
        love.graphics.rectangle("fill", EMIActive.x, EMIActive.y, EMIActive.Width * ratio_EMI, EMIActive.Height)
        love.graphics.setColor(1,1,1)
    end

    for k,v in ipairs(list_tank_E) do 
        love.graphics.setColor(love.math.colorFromBytes(231,50,36))
        love.graphics.rectangle("fill", v.x - largeurImg_tank_E/2 , v.y - hauteurImg_tank_E/2, v.life * 10, 4)
        love.graphics.setColor(1,1,1) 
    end

end

return HUD