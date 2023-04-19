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
    tankEnmy.x = 0
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

function Ennemies.Spawn(dt)
    timer = timer - dt
    if timer <= 0 then
        CreerEnnemy()
        timer = timerEnnemy
    end
    local n
    for n =#listTankEnmy, 1, -1 do 
        local t = listTankEnmy[n]
        t.x = t.x + t.vitesse * dt
        if t.x > lScreen then
            table.remove(listTankEnmy, n)
        end
    end
end

function Ennemies.Dead()
    local n
    for no = #listObus, 1, -1 do 
        local o = listObus[no]
        for nt = #listTankEnmy, 1, -1 do 
        local t = listTankEnmy[nt]
        local dist = math.dist(t.x, t.y, o.x, o.y)
            if  dist < largeurTankEnemyImg/2 then
                table.remove(listTankEnmy, nt)
                table.remove(listObus, no)
            end
        end
    end
end

function Ennemies.Draw()
    --love.graphics.print(timer)
    --love.graphics.print(#listTankEnmy, 300, 300)
    love.graphics.print(tostring(#listObus), 400,400)
    love.graphics.print(tostring(dist), 500,400)


    for n=1, #listTankEnmy do 
        local t = listTankEnmy[n]
        love.graphics.draw(tankEnmyImg,t.x, t.y)
    end 
end

return Ennemies