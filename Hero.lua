if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

Hero = {}

local Weapons = require ("Weapons")
local HUD = require ("HUD")
local loot = require ("Loot")

Player = {}
Player.x = 200
Player.y = 200
Player.angle = 0
Player.life = 100

local vitessex = 200  
local vitessey = 200  

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
end

function Hero.Move(dt)
    -- Mouvements 
    if love.keyboard.isDown('z') then
        Player.x = Player.x + vitessex * math.cos(Player.angle) * dt
        Player.y = Player.y + vitessey * math.sin(Player.angle) * dt
    end
    if love.keyboard.isDown('s') then
        Player.x = Player.x - vitessex * math.cos(Player.angle) * dt
        Player.y = Player.y - vitessey * math.sin(Player.angle) * dt
    end
    if love.keyboard.isDown('q') then
        Player.angle = Player.angle - 3 * dt
    end
    if love.keyboard.isDown('d') then
        Player.angle = Player.angle + 3 * dt
    end

    -- Collisions
    if Player.x + largeurImg_Player/2 >= lScreen then
        Player.x = lScreen - largeurImg_Player/2
    end

    if Player.x - largeurImg_Player/2 <= 0  then 
        Player.x = largeurImg_Player/2
    end

    if Player.y + hauteurImg_Player/2 >= hScreen then
        Player.y = hScreen - hauteurImg_Player/2
    end

    if Player.y - hauteurImg_Player/2 <= 0  then 
        Player.y = hauteurImg_Player/2
    end
    
    for k,v in ipairs (list_tank_E) do 
        if CheckCollision(Player.x, Player.y, largeurImg_Player, hauteurImg_Player, v.x, v.y, largeurImg_tank_E, hauteurImg_tank_E) == true then 
           
            if Player.x - largeurImg_Player/2 < v.x + largeurImg_tank_E / 2  then 
                Player.x  = v.x + largeurImg_tank_E/2 + largeurImg_Player/2
            end
            if Player.x + largeurImg_Player/2 < v.x - largeurImg_tank_E / 2  then 
                Player.x  = v.x - largeurImg_tank_E/2 - largeurImg_Player/2
            end

        
        end
    end
end

function Hero.Canon()
    local mousex = love.mouse.getX()
    local mousey = love.mouse.getY()
    angle_Canon = math.angle(Player.x, Player.y, mousex, mousey)
end

function Hero.IsHit()
    local no
        for no = #listObus, 1, -1 do 
            local o = listObus[no]
            if o.nom == NomObusEnnemy then 
                local dist = math.dist(Player.x, Player.y, o.x, o.y)
                if Shield_ON == false then
                    if  dist < largeurImg_Player/2 then
                        table.remove(listObus, no)
                        HUD.RemoveHeroLife(dt)
                    end
                end
                if Shield_ON == true then 
                    if  dist <= Shield_Radius then
                        table.remove(listObus, no)
                    end
                end
            end
        end
end


function Hero.Draw()
    for k,v in ipairs (listObus) do 
        love.graphics.draw (Img_Obus, v.x, v.y, v.angle, 1/2, 1/2, largeurImg_Obus /2, hauteurImg_Obus /2 )
    end
    love.graphics.draw(Img_Player, Player.x, Player.y, Player.angle, 1,1, largeurImg_Player /2 , hauteurImg_Player /2 )
    love.graphics.draw(Img_Canon, Player.x, Player.y, angle_Canon, 1,1,largeurImg_Canon /2 , hauteurImg_Canon /2 )
    love.graphics.circle('fill', Player.x - largeurImg_Player/2, Player.y, 4)
    love.graphics.setColor(1,0,1)
    love.graphics.circle('fill', Player.x + largeurImg_Player/2, Player.y, 4)
    love.graphics.setColor(1,1,1)

    for k,v in ipairs (list_tank_E) do 
        love.graphics.print(tostring(CheckCollision(Player.x, Player.y, largeurImg_Player, hauteurImg_Player, v.x, v.y, largeurImg_tank_E, hauteurImg_tank_E)), 300, 10)
    end
end

function Hero.MouseShootCanon()
    function love.mousepressed(x, y, button)
        if WeaponTypes == W_Types.Basic then 
            if button == 1 then 
                Weapons.CreerObus(NomObusHero, Player.x, Player.y, angle_Canon, 500)
            end
        end

        if WeaponTypes == W_Types.Heavy then 
            if button == 1 then 
                Weapons.CreerObus(NomObusHero, Player.x, Player.y, angle_Canon, 1000)
            end
        end
    end
end


return Hero