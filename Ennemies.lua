if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

local Ennemis = {}

local Weapons = require("Weapons")
local TankJoueur = require("Hero")
local GUI = require("GUI")
local Loot = require("Loot")
local Carte = require("maps")

-- TYPES ENNEMIES
Ennemis_Types = {}
Ennemis_Types.TOWER = "TOWER"
Ennemis_Types.TANK = "TANK"

-- ETAT TANK
local ET_TANK_E = {}
ET_TANK_E.IDLE = "IDLE"
ET_TANK_E.MOVE = "MOVE"
ET_TANK_E.CHASE = "CHASE"
ET_TANK_E.SHOOT = "SHOOT"
ET_TANK_E.COL_PLAYER = "COLLISION_P"
ET_TANK_E.COL_ENNEMY = "COLLISION_E"
ET_TANK_E.COL_LAYERS = "COLLISION_L"
ET_TANK_E.REPOSITION = "REPOSITION"
ET_TANK_E.ETAT_DEAD = "DEAD"

-- ETAT TOURS
local TOWER_E = {}
TOWER_E.IDLE = "IDLE"
TOWER_E.PLAYER_DETECTED = "DETECTED"
TOWER_E.SHOOT = "SHOOT"
TOWER_E.COL_PLAYER = "COLLISIONP"
TOWER_E.COL_ENNEMY = "COLLISIONE"
TOWER_E.ETAT_DEAD = "DEAD"

function Ennemis.Load()
    Img_tank_E = love.graphics.newImage("Images/Badtank.png")
    largeurImg_tank_E = Img_tank_E:getWidth()
    hauteurImg_tank_E = Img_tank_E:getHeight()

    Img_Tower = love.graphics.newImage("Images/Pilliers.png")
    largeurImg_Tower = Img_Tower:getWidth()
    hauteurImg_Tower = Img_Tower:getHeight()
    Img_Tower1 = love.graphics.newQuad(0, 0, 27, 66, largeurImg_Tower, hauteurImg_Tower)
    Img_Tower2 = love.graphics.newQuad(27, 0, 27, 66, largeurImg_Tower, hauteurImg_Tower)
    Img_Tower3 = love.graphics.newQuad(54, 0, 27, 66, largeurImg_Tower, hauteurImg_Tower)

    Ennemis.Start()
end

-- FONCTION INITIALISATION
function Ennemis.Start()
    list_Ennemis = {}
    function Ennemis.CreerEnnemy(
        pNom,
        pX,
        pY,
        pVitesse,
        pAngle,
        pLife,
        pEtat,
        pDistance,
        pDice,
        pDectection,
        pShoot,
        pTimer,
        pSpeedShoot,
        pTimerReloc,
        pReloc)
        local tank_E = {}
        tank_E.nom = pNom
        tank_E.x = pX
        tank_E.y = pY
        tank_E.vitesse = pVitesse
        tank_E.angle = pAngle
        tank_E.life = pLife
        tank_E.etat = pEtat
        tank_E.dist = pDistance
        tank_E.Dice = pDice
        tank_E.Detection = pDectection
        tank_E.Shoot = pShoot
        tank_E.Timer_Shoot = pTimer
        tank_E.SpeedShoot = pSpeedShoot
        tank_E.TimerReloc = pTimerReloc
        tank_E.Relocation = pReloc
        table.insert(list_Ennemis, tank_E)
    end
    Ennemis.CreerEnnemy(Ennemis_Types.TOWER, 200, 500, nil, 0, 10, TOWER_E.IDLE, 0, 0, false, false, 0, 0.5, nil, nil)
    Ennemis.CreerEnnemy(Ennemis_Types.TOWER, 900, 500, nil, 0, 10, TOWER_E.IDLE, 0, 0, false, false, 0, 0.5, nil, nil)
end

-- TIMER
local Ennemis_Spawn = 2
local timer_Spawn = Ennemis_Spawn
--local Ennemis_Shoot = 1
--local timer_Shoot = Ennemis_Shoot

-- MACHINE A ETATS
function Ennemis.Etats(dt)
    local n
    for n = #list_Ennemis, 1, -1 do
        local t = list_Ennemis[n]
        if t.nom == Ennemis_Types.TANK then
            chase_Dist = 200
            shoot_Dist = 150
            col_Player_Dist = 90
            t.dist = math.dist(t.x, t.y, Player.x, Player.y)

            if t.etat == ET_TANK_E.IDLE then
                t.etat = ET_TANK_E.MOVE
            elseif t.etat == ET_TANK_E.MOVE then
                local oldtx = t.x
                local oldty = t.y
                t.x = t.x + t.vitesse * math.cos(t.angle) * dt
                t.y = t.y + t.vitesse * math.sin(t.angle) * dt

                local nbligne = #list_Layers.background / TILE_WIDTH
                local nbcol = TILE_HEIGHT
                local l, c
                Collision = false
                for l = nbligne, 1, -1 do
                    for c = 1, nbcol do
                        local tuile = list_Layers.walls[((l - 1) * TILE_HEIGHT) + c]
                        if tuile > 0 then
                            if
                                CheckCollision(
                                    t.x,
                                    t.y,
                                    largeurImg_Player,
                                    hauteurImg_Player,
                                    c * TILE_WIDTH,
                                    l * TILE_HEIGHT,
                                    TILE_WIDTH,
                                    TILE_HEIGHT
                                ) == true
                             then
                                Collision = true
                                t.x = oldtx
                                t.y = oldty
                                t.etat = ET_TANK_E.COL_LAYERS
                            end
                        end
                    end
                end

                for k, v in ipairs(list_Ennemis) do
                    local oldvx = v.x
                    local oldvy = v.y
                    local col_Ennemy_Dist = math.dist(v.x, v.y, t.x, t.y)
                    if v ~= t then
                        if col_Ennemy_Dist < largeurImg_tank_E then
                            v.x = oldvx
                            v.y = oldvy
                            t.x = oldtx
                            t.y = oldty
                            t.etat = ET_TANK_E.COL_ENNEMY
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

                local nbligne = #list_Layers.background / TILE_WIDTH
                local nbcol = TILE_HEIGHT
                local l, c
                Collision = false
                for l = nbligne, 1, -1 do
                    for c = 1, nbcol do
                        local tuile = list_Layers.walls[((l - 1) * TILE_HEIGHT) + c]
                        if tuile > 0 then
                            if
                                CheckCollision(
                                    t.x,
                                    t.y,
                                    largeurImg_Player,
                                    hauteurImg_Player,
                                    c * TILE_WIDTH,
                                    l * TILE_HEIGHT,
                                    TILE_WIDTH,
                                    TILE_HEIGHT
                                ) == true
                             then
                                Collision = true
                                t.x = oldtx
                                t.y = oldty
                                t.etat = ET_TANK_E.COL_LAYERS
                            end
                        end
                    end
                end

                for k, v in ipairs(list_Ennemis) do
                    local oldvx = v.x
                    local oldvy = v.y
                    local col_Ennemy_Dist = math.dist(v.x, v.y, t.x, t.y)
                    if v ~= t then
                        if col_Ennemy_Dist < largeurImg_tank_E then
                            v.x = oldvx
                            v.y = oldvy
                            t.x = oldtx
                            t.y = oldty
                            t.etat = ET_TANK_E.COL_ENNEMY
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
                --
                local oldtx = t.x
                local oldty = t.y

                t.angle = math.angle(t.x, t.y, Player.x, Player.y)
                t.x = t.x + t.vitesse * math.cos(t.angle) * dt
                t.y = t.y + t.vitesse * math.sin(t.angle) * dt

                local nbligne = #list_Layers.background / TILE_WIDTH
                local nbcol = TILE_HEIGHT
                local l, c
                Collision = false
                for l = nbligne, 1, -1 do
                    for c = 1, nbcol do
                        local tuile = list_Layers.walls[((l - 1) * TILE_HEIGHT) + c]
                        if tuile > 0 then
                            if
                                CheckCollision(
                                    t.x,
                                    t.y,
                                    largeurImg_Player,
                                    hauteurImg_Player,
                                    c * TILE_WIDTH,
                                    l * TILE_HEIGHT,
                                    TILE_WIDTH,
                                    TILE_HEIGHT
                                ) == true
                             then
                                Collision = true
                                t.x = oldtx
                                t.y = oldty
                                t.etat = ET_TANK_E.COL_LAYERS
                            end
                        end
                    end
                end

                for k, v in ipairs(list_Ennemis) do
                    local oldvx = v.x
                    local oldvy = v.y
                    local col_Ennemy_Dist = math.dist(v.x, v.y, t.x, t.y)
                    if v ~= t then
                        if col_Ennemy_Dist < largeurImg_tank_E then
                            v.x = oldvx
                            v.y = oldvy
                            t.x = oldtx
                            t.y = oldty
                            t.etat = ET_TANK_E.COL_ENNEMY
                        end
                    end
                end

                t.Timer_Shoot = t.Timer_Shoot + dt
                if t.Timer_Shoot > t.SpeedShoot then
                    Weapons.CreerObus(ObusEnnemis, t.x, t.y, t.angle, 500)
                    t.Timer_Shoot = 0
                end

                if t.dist <= col_Player_Dist then
                    t.etat = ET_TANK_E.COL_PLAYER
                end
            elseif t.etat == ET_TANK_E.COL_LAYERS then
                t.etat = ET_TANK_E.REPOSITION
            elseif t.etat == ET_TANK_E.REPOSITION then
                OldAngle = t.angle
                t.TimerReloc = t.TimerReloc + dt
                t.angle = math.pi + 1
                if t.TimerReloc <= t.Relocation then
                    t.x = t.x + t.vitesse * math.cos(t.angle) * dt
                    t.y = t.y + t.vitesse * math.sin(t.angle) * dt
                elseif t.TimerReloc >= t.Relocation then
                    t.angle = math.angle(t.x, t.y, Player.x, Player.y)
                    t.TimerReloc = 0
                    t.etat = ET_TANK_E.MOVE
                end
            elseif t.etat == ET_TANK_E.COL_ENNEMY then
                t.angle = math.pi
                t.x = t.x + t.vitesse * math.cos(t.angle) * dt
                t.y = t.y + t.vitesse * math.sin(t.angle) * dt
                t.etat = ET_TANK_E.MOVE
            elseif t.etat == ET_TANK_E.COL_PLAYER then
                t.angle = math.angle(t.x, t.y, Player.x, Player.y)
                t.Timer_Shoot = t.Timer_Shoot + dt

                if t.Timer_Shoot > t.SpeedShoot then
                    Weapons.CreerObus(ObusEnnemis, t.x, t.y, t.angle, 500)
                    t.Timer_Shoot = 0
                end

                if t.dist >= col_Player_Dist then
                    t.etat = ET_TANK_E.CHASE
                end
            end
        elseif t.nom == Ennemis_Types.TOWER then
            local rayon_Detection = 200
            local rayon_Shoot = 150
            t.dist = math.dist(t.x, t.y, Player.x, Player.y)

            if t.etat == TOWER_E.IDLE then
                if t.dist < rayon_Detection then
                    t.etat = TOWER_E.PLAYER_DETECTED
                    t.Detection = true
                end
            elseif t.etat == TOWER_E.PLAYER_DETECTED then
                if t.dist < rayon_Shoot then
                    t.Detection = false
                    t.etat = TOWER_E.SHOOT
                    t.Shoot = true
                end

                if t.dist > rayon_Detection then
                    t.Detection = false
                    t.Shoot = false
                    t.etat = TOWER_E.IDLE
                end
            elseif t.etat == TOWER_E.SHOOT then
                t.Shoot = true
                t.angle = math.angle(t.x, t.y, Player.x, Player.y)
                t.Timer_Shoot = t.Timer_Shoot - dt
                if t.Timer_Shoot < 0 then
                    Weapons.CreerObus(LaserTower, t.x, t.y, t.angle, 500)
                    t.Timer_Shoot = t.SpeedShoot
                elseif t.dist > rayon_Shoot then
                    t.etat = TOWER_E.PLAYER_DETECTED
                    t.Shoot = false
                    t.Detection = true
                elseif t.dist > rayon_Detection then
                    t.etat = TOWER_E.IDLE
                    t.Detection = false
                end
            end
        end
    end
end

-- FONCTIONS SI L'ENNEMI EST TOUCHE
function Ennemis.IsHit()
    local no
    for no = #listObus, 1, -1 do
        local o = listObus[no]
        if o.nom == ObusHero then
            for nt = #list_Ennemis, 1, -1 do
                local t = list_Ennemis[nt]
                if t.nom == Ennemis_Types.TANK then
                    local dist = math.dist(t.x, t.y, o.x, o.y)
                    if dist < largeurImg_tank_E / 2 then
                        table.remove(listObus, no)
                        t.life = t.life - 1
                        if t.life == 0 then
                            local dice = love.math.random(0, 10)
                            if dice >= 0 and dice <= 3 then
                                Loot.CreerLoot("SHIELD", t.x, t.y)
                            elseif dice >= 4 and dice <= 5 then
                                Loot.CreerLoot("SMALL", t.x, t.y)
                            elseif dice >= 6 and dice <= 7 then
                                Loot.CreerLoot("BIG", t.x, t.y)
                            end
                            GUI.AddScore()
                            table.remove(list_Ennemis, nt)
                        end
                    end
                elseif t.nom == Ennemis_Types.TOWER then
                    local dist = math.dist(t.x, t.y, o.x, o.y)
                    if dist < largeurImg_Tower / 2 then
                        t.life = t.life - 1
                        table.remove(listObus, no)
                        if t.life == 0 then
                            local dice = love.math.random(0, 10)
                            if dice >= 0 and dice <= 3 then
                                Loot.CreerLoot("SHIELD", t.x, t.y)
                            elseif dice >= 4 and dice <= 5 then
                                Loot.CreerLoot("SMALL", t.x, t.y)
                            elseif dice >= 6 and dice <= 7 then
                                Loot.CreerLoot("BIG", t.x, t.y)
                            end
                            GUI.AddScore()
                            table.remove(list_Ennemis, nt)
                        end
                    end
                end
            end
        end
    end
end

function Ennemis.IsHitHeavy()
    local nt
    for nt = #list_Ennemis, 1, -1 do
        local t = list_Ennemis[nt]
        local Impact_dist = EMI_Radius_Init
        local Impact_dist = math.dist(t.x, t.y, Player.x, Player.y)
        if Impact_dist <= EMI_Radius_Init then
            t.life = t.life - 1
            if t.life == 0 then
                GUI.AddScore()
                table.remove(list_Ennemis, nt)
            end
        end
    end
end

function Ennemis.Update(dt)
    timer_Spawn = timer_Spawn - dt
    if timer_Spawn <= 0 then
        pX = 100
        pY = love.math.random(100, 1000)

        Ennemis.CreerEnnemy(
            Ennemis_Types.TANK,
            pX,
            pY,
            100,
            2 * math.pi,
            5,
            ET_TANK_E.IDLE,
            0,
            0,
            nil,
            0,
            0,
            0.5,
            0,
            0.5
        )
        timer_Spawn = Ennemis_Spawn
    end

    Ennemis.Etats(dt)

    for n = #list_Ennemis, 1, -1 do
        local t = list_Ennemis[n]
        if t.x > lScreen then
            table.remove(list_Ennemis, n)
        end
    end
    Ennemis.IsHit()
    Ennemis.IsHitHeavy()
end

function Ennemis.Draw()
    for n = 1, #list_Ennemis do
        local t = list_Ennemis[n]
        if t.nom == Ennemis_Types.TANK then
            love.graphics.print(tostring(t.etat), t.x, t.y + 100)
            -- love.graphics.print(tostring(t.Dice), t.x, t.y + 100)
            love.graphics.print(tostring(t.TimerReloc), t.x, t.y + 200)
            love.graphics.draw(Img_tank_E, t.x, t.y, t.angle, 1, 1, largeurImg_tank_E / 2, hauteurImg_tank_E / 2)
        elseif t.nom == Ennemis_Types.TOWER then
            if t.Detection == false then
                love.graphics.draw(Img_Tower, Img_Tower1, t.x, t.y, 0, 1, 1, largeurImg_Tower / 2, hauteurImg_Tower / 2)
            elseif t.Detection == true then
                love.graphics.draw(Img_Tower, Img_Tower2, t.x, t.y, 0, 1, 1, largeurImg_Tower / 2, hauteurImg_Tower / 2)
            end
            if t.Shoot == true then
                love.graphics.draw(Img_Tower, Img_Tower3, t.x, t.y, 0, 1, 1, largeurImg_Tower / 2, hauteurImg_Tower / 2)
            end
            love.graphics.circle("fill", t.x - largeurImg_Tower / 3, t.y, 4)
        end
    end
end

return Ennemis
