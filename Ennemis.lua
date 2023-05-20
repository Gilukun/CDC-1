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
Nom_Ennemis = {}
Nom_Ennemis.TOWER = "TOWER"
Nom_Ennemis.TANK = "TANK"

-- ETAT TANK
local ET_TANK_E = {}
ET_TANK_E.IDLE = "IDLE"
ET_TANK_E.MOVE = "MOVE"
ET_TANK_E.CHASE = "CHASE"
ET_TANK_E.SHOOT = "SHOOT"
ET_TANK_E.COL_PLAYER = "COLLISION_P"
ET_TANK_E.COL_ENNEMY = "COLLISION_E"
ET_TANK_E.COL_LAYERS = "COLLISION_L"
ET_TANK_E.COL_ECRAN = "COLLISION_ECRAN"
ET_TANK_E.REPOSITION = "REPOSITION"
ET_TANK_E.SEEK = "SEEK"
ET_TANK_E.ETAT_DEAD = "DEAD"

-- ETAT TOURS
local TOWER_E = {}
TOWER_E.IDLE = "IDLE"
TOWER_E.PLAYER_DETECTED = "DETECTED"
TOWER_E.SHOOT = "SHOOT"
TOWER_E.COL_PLAYER = "COLLISIONP"
TOWER_E.COL_ENNEMY = "COLLISIONE"
TOWER_E.ETAT_DEAD = "DEAD"

-- ZONES DE SPAWN
local zone2Spawn = {}
-- haut gauche
zone2Spawn[1] = {
    x = 400,
    y = 100,
    angle = math.pi / 2
}

-- haut droite
zone2Spawn[2] = {
    x = 900,
    y = 350,
    angle = math.pi
}

-- bas gauche
zone2Spawn[3] = {
    x = 600,
    y = 900,
    angle = math.pi * 1.5
}

zone2Spawn[4] = {
    x = 100,
    y = 400,
    angle = math.pi * 1.5
}

local nEnnemy = 0
local nEnnemyMax = 10

function Ennemis.Load()
    Img_tank_E = love.graphics.newImage("Images/BadTank.png")
    largeurImg_tank_E = Img_tank_E:getWidth()
    hauteurImg_tank_E = Img_tank_E:getHeight()

    Img_Tower = love.graphics.newImage("Images/Pilliers.png")
    largeurImg_Tower = Img_Tower:getWidth()
    hauteurImg_Tower = Img_Tower:getHeight()
    Img_Tower1 = love.graphics.newQuad(0, 0, 27, 66, largeurImg_Tower, hauteurImg_Tower)
    Img_Tower2 = love.graphics.newQuad(27, 0, 27, 66, largeurImg_Tower, hauteurImg_Tower)
    Img_Tower3 = love.graphics.newQuad(54, 0, 27, 66, largeurImg_Tower, hauteurImg_Tower)
end

-- FONCTION INITIALISATION
function Ennemis.Start()
    list_Ennemis = {}
    nEnnemy = 0

    -- 2 TOURS SPAWN DES QUE LE JEU COMMENCE
    Ennemis.CreerEnnemy(
        Nom_Ennemis.TOWER,
        200,
        500,
        nil,
        0,
        20,
        TOWER_E.IDLE,
        0,
        false,
        false,
        0,
        0.5,
        nil,
        nil,
        false,
        5
    )
    Ennemis.CreerEnnemy(
        Nom_Ennemis.TOWER,
        900,
        500,
        nil,
        0,
        20,
        TOWER_E.IDLE,
        0,
        false,
        false,
        0,
        0.5,
        nil,
        nil,
        false,
        5
    )
end

function Ennemis.CreerEnnemy(
    pNom,
    pX,
    pY,
    pVitesse,
    pAngle,
    pLife,
    pEtat,
    pDistance,
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
    tank_E.Detection = pDectection
    tank_E.Shoot = pShoot
    tank_E.Timer_Shoot = pTimer
    tank_E.SpeedShoot = pSpeedShoot
    tank_E.TimerReloc = pTimerReloc
    tank_E.Relocation = pReloc
    tank_E.alpha = 0
    tank_E.damage = 0
    table.insert(list_Ennemis, tank_E)
end
-- TIMER DE SPANW DES ENNEMIS
local Ennemis_Spawn = 2
local timer_Spawn = Ennemis_Spawn

-- MACHINE A ETATS DES ENNEMIS
function Ennemis.Etats(dt)
    local n
    for n = #list_Ennemis, 1, -1 do
        local t = list_Ennemis[n]
        if t.nom == Nom_Ennemis.TANK then
            -- ETATS DES TOURS
            -- ETATS DES TOURS
            chase_Dist = 200
            shoot_Dist = 150
            col_Player_Dist = largeurImg_Player
            t.dist = math.dist(t.x, t.y, Player.x, Player.y)

            if t.etat == ET_TANK_E.IDLE then
                t.etat = ET_TANK_E.MOVE
            elseif t.etat == ET_TANK_E.MOVE then
                -- L'ENNEMI ATTAQUE LE JOUEUR
                -- L'ENNEMY POURSUIS LE JOUEUR
                local oldtx = t.x
                local oldty = t.y
                -- t.angle = math.angle(t.x, t.y, Player.x, Player.y)
                t.x = t.x + t.vitesse * math.cos(t.angle) * dt
                t.y = t.y + t.vitesse * math.sin(t.angle) * dt

                -- COLLISIONS AVEC LES LAYERS
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
                                t.x = oldtx
                                t.y = oldty
                                t.etat = ET_TANK_E.REPOSITION
                            end
                        end
                    end
                end
                -- COLLISIONS ENTRE ENNEMIS
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
                            t.etat = ET_TANK_E.REPOSITION
                        end
                    end
                end
                -- COLLISIONS AVEC L'ECRAN
                if t.x + largeurImg_tank_E / 2 >= lScreen then
                    t.x = lScreen - largeurImg_tank_E / 2
                    t.etat = ET_TANK_E.REPOSITION
                end

                if t.x - largeurImg_tank_E / 2 <= 0 then
                    t.x = largeurImg_tank_E / 2
                    t.etat = ET_TANK_E.REPOSITION
                end

                if t.y + hauteurImg_tank_E / 2 >= hScreen then
                    t.y = hScreen - hauteurImg_tank_E / 2
                    t.etat = ET_TANK_E.REPOSITION
                end

                if t.y - hauteurImg_tank_E / 2 <= 0 then
                    t.y = hauteurImg_tank_E / 2
                    t.etat = ET_TANK_E.REPOSITION
                end
                if t.dist <= chase_Dist then
                    t.etat = ET_TANK_E.CHASE
                    oldangle = t.angle
                end
                -- COLLISIONS AVEC LE JOUEUR
                if t.dist <= col_Player_Dist then
                    t.etat = ET_TANK_E.COL_PLAYER
                end

                -- COLLISIONS AVEC LES PRISONNIERS
                for z = #PrisonerSpawn, 1, -1 do
                    local spawn = PrisonerSpawn[z]
                    if math.dist(t.x, t.y, spawn.x, spawn.y) < largeurImg_tank_E then
                        t.x = oldtx
                        t.y = oldty
                        t.etat = ET_TANK_E.REPOSITION
                    end
                end
            elseif t.etat == ET_TANK_E.CHASE then
                -- L'ENNEMI POURSUIT LE JOUEUR
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
                                t.etat = ET_TANK_E.REPOSITION
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
                            t.etat = ET_TANK_E.REPOSITION
                        end
                    end
                end

                for z = #PrisonerSpawn, 1, -1 do
                    local spawn = PrisonerSpawn[z]
                    if math.dist(t.x, t.y, spawn.x, spawn.y) < largeurImg_tank_E then
                        t.x = oldtx
                        t.y = oldty
                        t.etat = ET_TANK_E.REPOSITION
                    end
                end
                -- LE JOUEUR EST HORS DE PORTEE
                if t.dist >= chase_Dist then
                    t.etat = ET_TANK_E.MOVE
                    t.angle = oldangle
                end

                -- LE JOUEUR EST A PORTEE DE TIR
                if t.dist <= shoot_Dist then
                    t.etat = ET_TANK_E.SHOOT
                end
            elseif t.etat == ET_TANK_E.SHOOT then
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
                                t.etat = ET_TANK_E.REPOSITION
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
                            t.etat = ET_TANK_E.REPOSITION
                        end
                    end
                end

                for z = #PrisonerSpawn, 1, -1 do
                    local spawn = PrisonerSpawn[z]
                    if math.dist(t.x, t.y, spawn.x, spawn.y) < largeurImg_tank_E then
                        t.x = oldtx
                        t.y = oldty
                        t.etat = ET_TANK_E.REPOSITION
                    end
                end
                -- l'ennemi tir
                t.Timer_Shoot = t.Timer_Shoot + dt
                if t.Timer_Shoot > t.SpeedShoot then
                    Weapons.CreerObus(NomObus.Ennemis, t.x, t.y, t.angle, 500, 0.7)
                    Sd_SHOOT:stop()
                    Sd_SHOOT:play()
                    t.Timer_Shoot = 0
                end

                if t.dist <= col_Player_Dist then
                    t.etat = ET_TANK_E.COL_PLAYER
                end
            elseif t.etat == ET_TANK_E.REPOSITION then
                -- L'ENNEMI CHERCHE UNE NOUVELLE DIRECTION
                -- le tank est entré en collision. Il t.relocation temps pour reculer
                t.TimerReloc = t.TimerReloc + dt
                if t.TimerReloc <= t.Relocation then
                    t.x = t.x - t.vitesse * math.cos(t.angle) * dt
                    t.y = t.y - t.vitesse * math.sin(t.angle) * dt
                elseif t.TimerReloc >= t.Relocation then
                    t.TimerReloc = 0
                    t.etat = ET_TANK_E.SEEK
                end

                if t.x + largeurImg_tank_E / 2 >= lScreen then
                    t.x = lScreen - largeurImg_tank_E / 2
                    t.etat = ET_TANK_E.REPOSITION
                end

                if t.x - largeurImg_tank_E / 2 <= 0 then
                    t.x = largeurImg_tank_E / 2
                    t.etat = ET_TANK_E.REPOSITION
                end

                if t.y + hauteurImg_tank_E / 2 >= hScreen then
                    t.y = hScreen - hauteurImg_tank_E / 2
                    t.etat = ET_TANK_E.REPOSITION
                end

                if t.y - hauteurImg_tank_E / 2 <= 0 then
                    t.y = hauteurImg_tank_E / 2
                    t.etat = ET_TANK_E.REPOSITION
                end
            elseif t.etat == ET_TANK_E.SEEK then
                -- L'ENNMI ENTRE EN CONTACT AVEC LE JOUEUR
                -- l'ennemi va ajouter un angle qui équivaut à un angle droit (math.pi * 1.5) à son angle actuel
                t.TimerReloc = t.TimerReloc + dt
                if t.TimerReloc >= t.Relocation then
                    t.angle = t.angle + (math.pi * 1.5 * dt) * 50
                end

                -- a la fin du timer il se dirige vers le nouvel angle
                if t.TimerReloc <= t.Relocation then
                elseif t.TimerReloc >= t.Relocation then
                    t.TimerReloc = 0
                    t.etat = ET_TANK_E.MOVE
                end
            elseif t.etat == ET_TANK_E.COL_PLAYER then
                -- il n'avance plus et s'oriente simplement pour tirer
                t.angle = math.angle(t.x, t.y, Player.x, Player.y)
                t.Timer_Shoot = t.Timer_Shoot + dt

                if t.Timer_Shoot > t.SpeedShoot then
                    Weapons.CreerObus(NomObus.Ennemis, t.x, t.y, t.angle, 500, 0.7)
                    t.Timer_Shoot = 0
                end

                if t.dist >= col_Player_Dist then
                    t.etat = ET_TANK_E.CHASE
                end
            end
        elseif t.nom == Nom_Ennemis.TOWER then
            local rayon_Detection = 250
            local rayon_Shoot = 200
            t.dist = math.dist(t.x, t.y, Player.x, Player.y)

            if t.etat == TOWER_E.IDLE then
                -- LA TOUR PASSE EN JOUEUR DETECTE
                -- en état IDLE la tour scan pour savoir si le joueur est à portée de detection
                if t.dist < rayon_Detection then
                    t.etat = TOWER_E.PLAYER_DETECTED
                    t.Detection = true
                end
            elseif t.etat == TOWER_E.PLAYER_DETECTED then
                -- LA TOUR PASSE EN MODE TIR
                -- si le joueur s'approche à porté de tir, la tour passe en etat SHOOT. Sinon elle repasse en état IDLE
                if t.dist < rayon_Shoot then
                    t.Detection = false
                    t.etat = TOWER_E.SHOOT
                end

                if t.dist > rayon_Detection then
                    t.Detection = false
                    t.etat = TOWER_E.IDLE
                end
            elseif t.etat == TOWER_E.SHOOT then
                t.Shoot = true
                t.angle = math.angle(t.x, t.y, Player.x, Player.y)
                t.Timer_Shoot = t.Timer_Shoot - dt
                if t.Timer_Shoot <= 0 then
                    Weapons.CreerObus(NomObus.LaserTower, t.x, t.y, t.angle, 500, 0.5)
                    Sd_TOWER:play()
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
        if o.nom == NomObus.Hero then
            for nt = #list_Ennemis, 1, -1 do
                local t = list_Ennemis[nt]
                -- partie si l'ennemi est un TANK
                if t.nom == Nom_Ennemis.TANK then
                    -- partie si l'ennemi est une TOUR
                    local dist = math.dist(t.x, t.y, o.x, o.y)
                    if dist < largeurImg_tank_E / 2 then
                        SFX_HIT_ENNEMY:stop()
                        SFX_HIT_ENNEMY:play()
                        table.remove(listObus, no)
                        CreerExplosion(t.x, t.y)

                        t.life = t.life - 1
                        if t.life <= 0 then
                            local dice = love.math.random(0, 10)
                            if dice >= 0 and dice <= 3 then
                                Loot.CreerLoot(TypeLoot.Shield, t.x, t.y)
                            elseif dice >= 4 and dice <= 5 then
                                Loot.CreerLoot(TypeLoot.AddLifeBig, t.x, t.y)
                            elseif dice >= 6 and dice <= 7 then
                                Loot.CreerLoot(TypeLoot.AddLifeSmall, t.x, t.y)
                            end
                            SFX_DEAD_ENNEMY:stop()
                            SFX_DEAD_ENNEMY:play()
                            GUI.AddScore()
                            table.remove(list_Ennemis, nt)
                            Weapons.Kill(t.x, t.y)
                        end
                    end
                elseif t.nom == Nom_Ennemis.TOWER then
                    local dist = math.dist(t.x, t.y, o.x, o.y)
                    if dist < largeurImg_Tower / 2 then
                        t.life = t.life - 1
                        SFX_HIT_ENNEMY:stop()
                        SFX_HIT_ENNEMY:play()
                        table.remove(listObus, no)
                        if t.life == 0 then
                            local dice = love.math.random(0, 10)
                            if dice >= 0 and dice <= 3 then
                                Loot.CreerLoot(TypeLoot.Shield, t.x, t.y)
                            elseif dice >= 4 and dice <= 5 then
                                Loot.CreerLoot(TypeLoot.AddLifeSmall, t.x, t.y)
                            elseif dice >= 6 and dice <= 7 then
                                Loot.CreerLoot(TypeLoot.AddLifeBig, t.x, t.y)
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
    -- je fais spwaner les ennemis aléatoirement sur les zones de spwan
    local diceZoneSpawn = math.random(1, #zone2Spawn)
    if timer_Spawn <= 0 then
        nEnnemy = nEnnemy + 1 -- je compte le nombre d'ennemi à l'écran
        if nEnnemy <= nEnnemyMax then
            -- lorsque le nombre d'ennemi atteint la limite que j'ai choisi je reset mon timer et j'arrête les spawn
            pX = zone2Spawn[diceZoneSpawn].x
            pY = zone2Spawn[diceZoneSpawn].y
            pAngle = zone2Spawn[diceZoneSpawn].angle

            Ennemis.CreerEnnemy(
                Nom_Ennemis.TANK,
                pX,
                pY,
                100,
                pAngle,
                5,
                ET_TANK_E.IDLE,
                0,
                nil,
                0,
                0,
                0.5,
                0,
                0.1,
                false,
                10
            )
            timer_Spawn = Ennemis_Spawn
        elseif nEnnemy >= nEnnemyMax then
            nEnnemy = nEnnemyMax
            timer_Spawn = Ennemis_Spawn
        end
    end

    -- UPDATE DES ETATS
    Ennemis.Etats(dt)
    -- UPDATE DES HITS
    Ennemis.IsHit()
    Ennemis.IsHitHeavy()

    -- UPDATE DE L'ALPHA DES TANK (apparition progressive)
    for k, e in ipairs(list_Ennemis) do
        if e.nom == Nom_Ennemis.TANK then
            if e.alpha <= 1 then
                e.alpha = e.alpha + dt
            end
        end
    end
end

function Ennemis.Draw()
    for n = 1, #list_Ennemis do
        local t = list_Ennemis[n]

        if t.nom == Nom_Ennemis.TANK then
            love.graphics.setColor(1, 1, 1, t.alpha)
            love.graphics.draw(Img_tank_E, t.x, t.y, t.angle, 1, 1, largeurImg_tank_E / 2, hauteurImg_tank_E / 2)
            love.graphics.setColor(1, 1, 1, 1)
        elseif t.nom == Nom_Ennemis.TOWER then
            if t.Detection == false then
                love.graphics.draw(Img_Tower, Img_Tower1, t.x, t.y, 0, 1, 1, largeurImg_Tower / 2, hauteurImg_Tower / 2)
            elseif t.Detection == true then
                love.graphics.draw(Img_Tower, Img_Tower2, t.x, t.y, 0, 1, 1, largeurImg_Tower / 2, hauteurImg_Tower / 2)
            end
            if t.Shoot == true then
                love.graphics.draw(Img_Tower, Img_Tower3, t.x, t.y, 0, 1, 1, largeurImg_Tower / 2, hauteurImg_Tower / 2)
            end
        end
        for k, o in ipairs(listObus) do
            if t.isHit == true then
                love.graphics.draw(Img_Hit, o.x, o.y, 0, 1, 1, Img_Hit:getWidth() / 2, Img_Hit:getHeight() / 2)
            end
        end
    end
end

return Ennemis
