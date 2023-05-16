if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

Hero = {}

local Weapons = require("Weapons")
local GUI = require("GUI")
local loot = require("Loot")
local Carte = require("Maps")

-- ETATS PLAYER
ETAT_PLAYER = {}
ETAT_PLAYER.IDLE = "IDLE"
ETAT_PLAYER.ALIVE = "ALIVE"
ETAT_PLAYER.DEAD = "DEAD"
ETAT_PLAYER.COLLISIONE = "COL_E"
ETAT_PLAYER.COLLISIONLAYER = "COL_L"

Player = {}
Player.x = 0
Player.y = 0
Player.angle = 0
Player.KeyPressed = false
Player.etat = ETAT_PLAYER.IDLE
Player.life = 100

local vitessex = 200
local vitessey = 200

function Hero.Start()
    Player.x = 400
    Player.y = 200
    Player.etat = ETAT_PLAYER.IDLE
    Player.angle = 0
    Player.KeyPressed = false
    Player.life = 100
end

function Hero.Load()
    lScreen = love.graphics.getWidth()
    hScreen = love.graphics.getHeight()

    Img_Player = love.graphics.newImage("Images/tank.png")
    largeurImg_Player = Img_Player:getWidth()
    hauteurImg_Player = Img_Player:getHeight()

    Img_Canon = love.graphics.newImage("Images/Canon.png")
    largeurImg_Canon = Img_Canon:getWidth()
    hauteurImg_Canon = Img_Canon:getHeight()

    Img_Obus = love.graphics.newImage("Images/Obus.png")
    largeurImg_Obus = Img_Obus:getWidth()
    hauteurImg_Obus = Img_Obus:getHeight()
    Hero.Start()
end

function Hero.IsHit()
    local no
    for no = #listObus, 1, -1 do
        local o = listObus[no]
        if o.nom == NomObus.Ennemis or o.nom == NomObus.LaserTower then
            local dist = math.dist(Player.x, Player.y, o.x, o.y)
            if Shield_ON == false then
                if dist < largeurImg_Player / 2 then
                    table.remove(listObus, no)
                    GUI.RemoveHeroLife(dt)
                end
            end
            if Shield_ON == true then
                if dist <= largueurIMG_Shield / 3 then
                    table.remove(listObus, no)
                end
            end
        end
    end
end

function Hero.Etats(dt)
    if Player.etat == ETAT_PLAYER.IDLE then
        Player.etat = ETAT_PLAYER.ALIVE
    elseif Player.etat == ETAT_PLAYER.ALIVE then
        oldx = Player.x
        oldy = Player.y
        if love.keyboard.isDown("z") then
            Player.x = Player.x + (vitessex * dt) * math.cos(Player.angle)
            Player.y = Player.y + (vitessey * dt) * math.sin(Player.angle)
        end
        if love.keyboard.isDown("s") then
            Player.x = Player.x - (vitessex * dt) * math.cos(Player.angle)
            Player.y = Player.y - (vitessey * dt) * math.sin(Player.angle)
        end
        if love.keyboard.isDown("q") then
            Player.angle = Player.angle - 3 * dt
        end
        if love.keyboard.isDown("d") then
            Player.angle = Player.angle + 3 * dt
        end

        for k, v in ipairs(list_Ennemis) do
            if v.nom == Nom_Ennemis.TANK then
                if math.dist(Player.x, Player.y, v.x, v.y) < largeurImg_Player then
                    Player.x = oldx
                    Player.y = oldy
                end
            elseif v.nom == Nom_Ennemis.TOWER then
                if math.dist(Player.x, Player.y, v.x - largeurImg_Tower / 3, v.y) < largeurImg_Player / 1.5 then
                    Player.x = oldx
                    Player.y = oldy
                end
            end
        end

        for z = #PrisonerSpawn, 1, -1 do
            local spawn = PrisonerSpawn[z]
            if
                math.dist(Player.x, Player.y, spawn.x + largeurPrisoner, spawn.y + hauteurPrisoner) <
                    largeurImg_Player / 1.5
             then
                prisoner.saved = true
                AddPrisonersScore()
                table.remove(PrisonerSpawn, z)
            end
        end

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
                            Player.x,
                            Player.y,
                            largeurImg_Player,
                            hauteurImg_Player,
                            c * TILE_WIDTH,
                            l * TILE_HEIGHT,
                            TILE_WIDTH,
                            TILE_HEIGHT
                        ) == true
                     then
                        Collision = true
                        Player.x = oldx
                        Player.y = oldy
                    end
                end
            end
        end

        for n = #list_Loot, 1, -1 do
            local l = list_Loot[n]
            if math.dist(Player.x, Player.y, l.x, l.y) < largeurImg_Player then
                GUI.AddLife()
                GUI.AddShield()
                table.remove(list_Loot, n)
            end
        end
    elseif Player.etat == ETAT_PLAYER.DEAD then
    end
end

-- VISEE AVEC LE CANON
function Hero.Canon()
    local mousex = love.mouse.getX()
    local mousey = love.mouse.getY()
    angle_Canon = math.angle(Player.x, Player.y, mousex, mousey)
end

function Hero.Move(dt)
    Hero.Etats(dt)

    if Player.x + largeurImg_Player / 2 >= lScreen then
        Player.x = lScreen - largeurImg_Player / 2
    end

    if Player.x - largeurImg_Player / 2 <= 0 then
        Player.x = largeurImg_Player / 2
    end

    if Player.y + hauteurImg_Player / 2 >= hScreen then
        Player.y = hScreen - hauteurImg_Player / 2
    end

    if Player.y - hauteurImg_Player / 2 <= 0 then
        Player.y = hauteurImg_Player / 2
    end

    Hero.IsHit()
    Hero.Canon()
end

function Hero.Draw()
    love.graphics.draw(Img_Player, Player.x, Player.y, Player.angle, 1, 1, largeurImg_Player / 2, hauteurImg_Player / 2)
    love.graphics.draw(Img_Canon, Player.x, Player.y, angle_Canon, 1, 1, largeurImg_Canon / 2, hauteurImg_Canon / 2)
    --love.graphics.print(tostring(Player.etat), Player.x, Player.y)
end

function love.mousepressed(x, y, button)
    if WeaponTypes == W_Types.Basic then
        if button == 1 then
            Weapons.CreerObus(NomObus.Hero, Player.x, Player.y, angle_Canon, 500)
            Sd_SHOOT:stop()
            Sd_SHOOT:play()
        end
    end
end

return Hero
