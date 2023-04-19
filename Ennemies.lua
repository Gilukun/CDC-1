if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

local TankJoueur= require("Hero")

local Ennemies = {}

listTankEnmy = {}
local timerEnnemy = 5
local timer = timerEnnemy

listEtatTankEnnemy = {}
listEtatTankEnnemy.ETAT_IDLE = "IDLE"
listEtatTankEnnemy.ETAT_CHASE = "CHASE"
listEtatTankEnnemy.ETAT_SHOOT = "SHOOT"


function CreerEnnemy()
    local tankEnmy = {}
    tankEnmy.x = love.math.random (0,200)
    tankEnmy.y = love.math.random(0,400)
    tankEnmy.vitesse = 150
    tankEnmy.angle = 0
    tankEnmy.etat = "IDLE"
    table.insert(listTankEnmy, tankEnmy)
end

function Ennemies.Load()
    tankEnmyImg = love.graphics.newImage("Images/Badtank.png")
    largeurTankEnemyImg = tankEnmyImg:getWidth()
    hauteurTankEnemyImg = tankEnmyImg:getHeight()
end

function Ennemies.Timer(dt)
    timer = timer - dt
    if timer <= 0 then
        CreerEnnemy()
        timer = timerEnnemy
    end
end

function Ennemies.Spawn(dt)
    local n
    for n =#listTankEnmy, 1, -1 do 
        local speed = listTankEnmy[n]
        speed.x = speed.x + speed.vitesse * dt
        if speed.x > lScreen then
            table.remove(listTankEnmy, n)
        end
    end
end 


function Ennemies.Draw()
    --love.graphics.print(timer)
    --love.graphics.print(#listTankEnmy, 300, 300)
    love.graphics.print(tostring(TankJoueur.largeurTankHeroImg), 400,400)

    for n=1, #listTankEnmy do 
        local t = listTankEnmy[n]
        love.graphics.draw(tankEnmyImg,t.x, t.y)
    end 
end

return Ennemies