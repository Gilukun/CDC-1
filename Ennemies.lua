if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

local Weapons = require("Weapons")
local TankJoueur = require("Hero")
local GUI = require("GUI")
local Loot = require("Loot")
local Carte = require("maps")

local Ennemis = {}

-- Etats des tanks ennemis
local ET_TANK_E = {}
ET_TANK_E.IDLE = "IDLE"
ET_TANK_E.MOVE = "MOVE"
ET_TANK_E.CHASE = "CHASE"
ET_TANK_E.SHOOT = "SHOOT"
ET_TANK_E.COL_PLAYER = "COLLISIONP"
ET_TANK_E.COL_ENNEMY = "COLLISIONE"
ET_TANK_E.REPOSITION = "REPOSITION"

ET_TANK_E.ETAT_DEAD = "DEAD"

function Ennemis.Start()
    list_tank_E = {}
    function CreerEnnemy()
        local tank_E = {}
        tank_E.x = love.math.random(200, 1024)
        tank_E.y = love.math.random(200, 1024)
        tank_E.vitesse = 100
        tank_E.angle = 0
        tank_E.life = 5
        tank_E.etat = ET_TANK_E.IDLE
        tank_E.dist = 0
        tank_E.IsAlive = true
        tank_E.Dice = 0
        table.insert(list_tank_E, tank_E)
    end
end

function Ennemis.Load()
    Img_tank_E = love.graphics.newImage("Images/Badtank.png")
    largeurImg_tank_E = Img_tank_E:getWidth()
    hauteurImg_tank_E = Img_tank_E:getHeight()
    Ennemis.Start()
end

-- Timers
local E_SPAWN_T = 2
local timer_Spawn = E_SPAWN_T
local E_SHOOT = 1
local timer_Shoot = E_SHOOT

function Ennemis.Etats(dt)
    local n
    for n = #list_tank_E, 1, -1 do
        local t = list_tank_E[n]
        chase_Dist = 200
        shoot_Dist = 150
        col_Player_Dist = 90
        t.dist = math.dist(t.x, t.y, Player.x, Player.y)

        if t.etat == ET_TANK_E.IDLE then
            t.etat = ET_TANK_E.MOVE
        elseif t.etat == ET_TANK_E.MOVE then
            local oldtx = t.x
            local oldty = t.y
            t.angle = math.angle(t.x, t.y, Player.x, Player.y)
            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt

            for k, v in ipairs(list_tank_E) do
                local oldvx = v.x
                local oldvy = v.y
                local col_Ennemy_Dist = math.dist(v.x, v.y, t.x, t.y)
                if v ~= t then
                    if col_Ennemy_Dist < largeurImg_tank_E then
                        v.x = oldvx
                        v.y = oldvy
                        t.x = oldtx
                        t.y = oldty
                    end
                end
            end

            if t.dist <= chase_Dist then
                t.etat = ET_TANK_E.CHASE
                oldangle = t.angle
            end

            if t.dist <= col_Player_Dist then
                t.etat = ET_TANK_E.COL_PLAYER
            end
        elseif t.etat == ET_TANK_E.CHASE then
            local oldtx = t.x
            local oldty = t.y

            t.angle = math.angle(t.x, t.y, Player.x, Player.y)
            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt

            for k, v in ipairs(list_tank_E) do
                local oldvx = v.x
                local oldvy = v.y
                local col_Ennemy_Dist = math.dist(v.x, v.y, t.x, t.y)
                if v ~= t then
                    if col_Ennemy_Dist < largeurImg_tank_E then
                        v.x = oldvx
                        v.y = oldvy
                        t.x = oldtx
                        t.y = oldty
                    end
                end
            end

            if t.dist >= chase_Dist then
                t.etat = ET_TANK_E.MOVE
                t.angle = oldangle
            end

            if t.dist <= shoot_Dist then
                t.etat = ET_TANK_E.SHOOT
            end
        elseif t.etat == ET_TANK_E.SHOOT then
            local oldtx = t.x
            local oldty = t.y

            t.angle = math.angle(t.x, t.y, Player.x, Player.y)
            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt

            for k, v in ipairs(list_tank_E) do
                local oldvx = v.x
                local oldvy = v.y
                local col_Ennemy_Dist = math.dist(v.x, v.y, t.x, t.y)
                if v ~= t then
                    if col_Ennemy_Dist < largeurImg_tank_E then
                        v.x = oldvx
                        v.y = oldvy
                        t.x = oldtx
                        t.y = oldty
                    end
                end
            end
            timer_Shoot = timer_Shoot - dt
            if timer_Shoot < 0 then
                Weapons.CreerObus(NomObusEnnemy, t.x, t.y, t.angle, 500)
                timer_Shoot = E_SHOOT
            end

            if t.dist <= col_Player_Dist then
                t.etat = ET_TANK_E.COL_PLAYER
            end
        elseif t.etat == ET_TANK_E.COL_PLAYER then
            t.angle = math.angle(t.x, t.y, Player.x, Player.y)
            timer_Shoot = timer_Shoot - dt
            if timer_Shoot < 0 then
                Weapons.CreerObus(NomObusEnnemy, t.x, t.y, t.angle, 500)
                timer_Shoot = E_SHOOT
            end

            if t.dist >= col_Player_Dist then
                t.etat = ET_TANK_E.CHASE
            end
        end
    end
end

function Ennemis.IsHit()
    local no
    for no = #listObus, 1, -1 do
        local o = listObus[no]
        if o.nom == NomObusHero then
            for nt = #list_tank_E, 1, -1 do
                local t = list_tank_E[nt]
                local dist = math.dist(t.x, t.y, o.x, o.y)
                if dist < largeurImg_tank_E / 2 then
                    table.remove(listObus, no)
                    t.life = t.life - 1
                    if t.life == 0 then
                        local dice = love.math.random(0, 10)
                        if dice >= 0 and dice <= 3 then
                            Loot.CreerLoot("SHIELD", t.x, t.y)
                        end
                        if dice >= 4 and dice <= 5 then
                            Loot.CreerLoot("SMALL", t.x, t.y)
                        end
                        if dice >= 6 and dice <= 7 then
                            Loot.CreerLoot("BIG", t.x, t.y)
                        end
                        GUI.AddScore()
                        table.remove(list_tank_E, nt)
                    end
                end
            end
        end
    end
end

function Ennemis.IsHitHeavy()
    local nt
    for nt = #list_tank_E, 1, -1 do
        local t = list_tank_E[nt]
        local Impact_dist = EMI_Radius_Init
        local Impact_dist = math.dist(t.x, t.y, Player.x, Player.y)
        if Impact_dist <= EMI_Radius_Init then
            t.life = t.life - 1
            if t.life == 0 then
                GUI.AddScore()
                table.remove(list_tank_E, nt)
            end
        end
    end
end

function Ennemis.Update(dt)
    timer_Spawn = timer_Spawn - dt
    if timer_Spawn <= 0 then
        CreerEnnemy()
        timer_Spawn = E_SPAWN_T
    end

    -- MACHINE A ETATS
    Ennemis.Etats(dt)
    -- Suppression des tanks hors de l'écran
    for n = #list_tank_E, 1, -1 do
        local t = list_tank_E[n]
        if t.x > lScreen then
            table.remove(list_tank_E, n)
        end
    end

    Ennemis.IsHit()
    Ennemis.IsHitHeavy()
end

function Ennemis.Draw()
    for n = 1, #list_tank_E do
        local t = list_tank_E[n]
        love.graphics.draw(Img_tank_E, t.x, t.y, t.angle, 1, 1, largeurImg_tank_E / 2, hauteurImg_tank_E / 2)
        love.graphics.print(tostring(t.etat), t.x, t.y)
        love.graphics.print(tostring(t.Dice), t.x, t.y + 100)
        love.graphics.print(tostring(t.Dice), t.x, t.y + 100)
        love.graphics.print(tostring(timerR), t.x, t.y + 200)
    end
    for k, v in ipairs(listObus) do
        love.graphics.draw(Img_Obus, v.x, v.y, v.angle, 1 / 2, 1 / 2, largeurImg_Obus / 2, hauteurImg_Obus / 2)
    end
end

return Ennemis
