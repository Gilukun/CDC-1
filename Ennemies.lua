if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

local Weapons = require ("Weapons")
local TankJoueur= require("Hero")
local HUD = require ("HUD")
local loot = require ("Loot")

local Ennemies = {}


local E_SPAWN_T = 5
local timerSpawn = E_SPAWN_T 
local E_SHOOT = 2
local timerShoot = E_SHOOT


ET_Tank_E = {}
ET_Tank_E.ETAT_IDLE = "IDLE"
ET_Tank_E.ETAT_MOVE = "MOVE"
ET_Tank_E.ETAT_CHASE = "CHASE"
ET_Tank_E.ETAT_SHOOT = "SHOOT"
ET_Tank_E.ETAT_COLLISION = "COLLISION"
ET_Tank_E.ETAT_DEAD = "DEAD"

listTankEnmy = {}
function CreerEnnemy()
    local tankEnmy = {}
    tankEnmy.x = 0
    tankEnmy.y = love.math.random(0,400)
    tankEnmy.vitesse = 100
    tankEnmy.angle = 0
    tankEnmy.life = 5
    tankEnmy.etat = ET_Tank_E.ETAT_IDLE
    tankEnmy.dist = 0
    table.insert(listTankEnmy, tankEnmy)
end

function Collision(px1,py1, px2, py2, pangle)
    pangle = math.angle(px1,py1,px2,py2)
    px1 = px1
    py1 = py1
    px2 = px2 
    py2 = py2

end

function Ennemies.Load()
    tankEnmyImg = love.graphics.newImage("Images/Badtank.png")
    largeurTankEnemyImg = tankEnmyImg:getWidth()
    hauteurTankEnemyImg = tankEnmyImg:getHeight()

    spawnSFX = love.audio.newSource("Sounds/mooing-cow-122255.mp3", "static")
end


function Ennemies.Spawn(dt)
    timerSpawn = timerSpawn - dt
    if timerSpawn <= 0 then
        CreerEnnemy()
        timerSpawn = E_SPAWN_T
        -- spawnSFX:play()
    end
    local n
    for n =#listTankEnmy, 1, -1 do 
        local t = listTankEnmy[n]

-- Machine à ETATS
        chase_Dist = 250
        shoot_Dist = 200
        col_dist = 150
        t.dist = math.dist(t.x,t.y, tankHero.x,tankHero.y)

        if t.etat == ET_Tank_E.ETAT_IDLE then
            t.etat = ET_Tank_E.ETAT_MOVE

        elseif t.etat == ET_Tank_E.ETAT_MOVE then 
            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt
            
            if t.dist <= chase_Dist then
                t.etat = ET_Tank_E.ETAT_CHASE
            end

        elseif t.etat == ET_Tank_E.ETAT_CHASE then
            t.angle = math.angle(t.x,t.y, tankHero.x,tankHero.y)
            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt

            if t.dist >= chase_Dist then
                t.etat = ET_Tank_E.ETAT_MOVE
            end
            
            if t.dist <= shoot_Dist then 
                t.etat = ET_Tank_E.ETAT_SHOOT
            end

        elseif t.etat == ET_Tank_E.ETAT_SHOOT then 
            t.angle = math.angle(t.x,t.y, tankHero.x,tankHero.y)
            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt

            timerShoot = timerShoot - dt
            if timerShoot < 0 then 
               Weapons.CreerObus(NomObusEnnemy, t.x, t.y, t.angle, 500)
                timerShoot = E_SHOOT
            end

            if t.dist <= col_dist then
                t.etat= ET_Tank_E.ETAT_COLLISION
            end

        elseif t.etat == ET_Tank_E.ETAT_COLLISION then
            t.angle = math.angle(t.x,t.y, tankHero.x,tankHero.y)
            timerShoot = timerShoot - dt
            if timerShoot < 0 then 
                Weapons.CreerObus(NomObusEnnemy,t.x, t.y, t.angle, 500)
                timerShoot = E_SHOOT
            end

            if t.dist > col_dist then
                t.etat= ET_Tank_E.ETAT_CHASE
            end
        elseif t.etat == ET_Tank_E.ETAT_DEAD then 
        end

-- Suppression des tanks hors de l'écran
        if t.x > lScreen then
            table.remove(listTankEnmy, n)
        end
    end

end


function Ennemies.IsHit()
    local no
    for no = #listObus, 1, -1 do 
        local o = listObus[no]
        if o.nom == NomObusHero then 
            for nt = #listTankEnmy, 1, -1 do 
            local t = listTankEnmy[nt]
            local dist = math.dist(t.x, t.y, o.x, o.y)
                if  dist < largeurTankEnemyImg/2 then
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
end

function Ennemies.IsHitHeavy()
    local nt
    for nt = #listTankEnmy, 1, -1 do 
        local t = listTankEnmy[nt]
        local distImpact = EMI_Radius_Init
        local distImpact = math.dist(t.x, t.y,tankHero.x,tankHero.y )
        if distImpact <= EMI_Radius_Init then 
            t.life = t.life - 1
            if t.life == 0 then 
                table.remove(listTankEnmy, nt)
                HUD.AddScore()
                loot.DropLoot()
            end
        end
    end
end

function Ennemies.Draw()
    for n=1, #listTankEnmy do 
        local t = listTankEnmy[n]
        love.graphics.draw(tankEnmyImg,t.x, t.y, t.angle, 1,1, largeurTankEnemyImg /2 , hauteurTankEnemyImg / 2)
        love.graphics.setColor(love.math.colorFromBytes(231,50,36))
        love.graphics.rectangle("fill", t.x, t.y - hauteurTankEnemyImg/8, t.life * 10, 4)
        love.graphics.setColor(1,1,1) 
    end 
    for k,v in ipairs (listObus) do 
        love.graphics.draw(obusImg, v.x, v.y, v.angle, 1/2, 1/2, largeurObusImg/2, hauteurObusImg/2 )
    end

end


return Ennemies