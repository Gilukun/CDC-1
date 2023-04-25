if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

local TankJoueur= require("Hero")
local HUD = require ("HUD")
local loot = require ("Loot")

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
    tankEnmy.y = love.math.random(0,200)
    tankEnmy.vitesse = 150
    tankEnmy.angle = 0
    tankEnmy.life = 5
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
            if  dist < largeurTankEnemyImg then
                table.remove(listObus, no)
                t.life = t.life - 1
                if t.life == 0 then 
                    table.remove(listTankEnmy, nt)
                    HUD.AddScore()
                    loot.DropLoot()
                end
            end
        end
    end
end

function Ennemies.Draw()
    love.graphics.print(tostring(#listObus), 400,10)
    for nt = #listTankEnmy, 1, -1 do 
        local t = listTankEnmy[nt]
        love.graphics.print(tostring(listTankEnmy[nt].life), 500,10)
    end

    for n=1, #listTankEnmy do 
        local t = listTankEnmy[n]
        love.graphics.draw(tankEnmyImg,t.x, t.y)
        love.graphics.setColor(love.math.colorFromBytes(231,50,36))
        love.graphics.rectangle("fill", t.x, t.y - hauteurTankEnemyImg/8, t.life * 10, 4)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line",t.x , t.y, tankEnmyImg:getWidth(), tankEnmyImg:getHeight())
    end 
    
end

return Ennemies