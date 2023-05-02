Menu = {}

local flash= 2
local timer = flash

local pressStart = true

function Menu.Load()
    Menu_Background = love.graphics.newImage("Images/MenuImg.jpg") 
    Img_enter = love.graphics.newImage("Images/PressEnter.png")
    Img_Press_enter = love.graphics.newImage("Images/PressEntertxt.png")

end

function Menu.Update(dt)
    if timer > 1 then 
        pressStart = true 
        timer = timer - dt
    end
    if timer < 1 then 
        timer = timer - dt
        pressStart = false
    end
    if timer <= 0 then 
        timer = flash
    end
end

function Menu.Draw()
    love.graphics.draw(Menu_Background)
    if pressStart == true then
        love.graphics.setColor(1,1,1,0.7)
        love.graphics.draw(Img_enter, love.graphics.getWidth()/2, love.graphics.getHeight()/2 + Img_Press_enter:getHeight()/2 )
        love.graphics.draw(Img_Press_enter,love.graphics.getWidth()/2, love.graphics.getHeight()/2,0,1,1,Img_Press_enter:getWidth()/2, Img_Press_enter:getHeight()/2)
        love.graphics.setColor(1,1,1)
    end
end

return Menu