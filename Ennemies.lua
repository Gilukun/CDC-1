if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

local Ennemies = {}

listTankEnmy = {}
local timerEnnemy = 5
local timer = timerEnnemy

function CreerEnnemy()
    local tankEnmy = {}
    tankEnmy.x = love.math.random (0,200)
    tankEnmy.y = love.math.random(0,400)
    tankEnmy.vitesse = love.math.random(100,300)
    tankEnmy.angle = 0
    table.insert(listTankEnmy, tankEnmy)
end

function Ennemies.Load()
    tankEnmyImg = love.graphics.newImage("Images/Badtank.png")
end

function Ennemies.Update(dt)
    timer = timer - dt
    if timer <= 0 then
        CreerEnnemy()
        timer = timerEnnemy
    end

    for n = 1, #listTankEnmy do 
        local v = listTankEnmy[n]
        v.x = v.x + v.vitesse * dt
    end
   
end

function Ennemies.Draw()
    love.graphics.print(timer)

    for n=1, #listTankEnmy do 
        local t = listTankEnmy[n]
        love.graphics.draw(tankEnmyImg,t.x, t.y)
    end

end

function Ennemies.keypressed(key)
end

return Ennemies