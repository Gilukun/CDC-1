if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

Hero = {}

local Weapons = require ("WeaponsHero")
local HUD = require ("HUD")
local loot = require ("Loot")


tankHero = {}
tankHero.x = 200
tankHero.y = 200
tankHero.vx = 0
tankHero.vy = 0
tankHero.angle = 0
tankHero.life = 100

local vitessex = 200  
local vitessey = 200  

TH_STATUS = {}
TH_STATUS.IDLE = "IDLE"
TH_STATUS.MOVE = "MOVE"
TH_STATUS.SHOOT = "SHOOT"
TH_STATUS.DEAD = "DEAD"

function Hero.Load()
    lScreen = love.graphics.getWidth()
    hScreen = love.graphics.getHeight()

    tankHeroImg = love.graphics.newImage("Images/tank.png")
    largeurTankHeroImg = tankHeroImg:getWidth()
    hauteurTankHeroImg = tankHeroImg:getHeight()

    canonHeroImg = love.graphics.newImage("Images/Canon.png")
    largeurCanonHeroImg = canonHeroImg:getWidth()
    hauteurCanonHeroImg = canonHeroImg:getHeight()

    obusImg = love.graphics.newImage("Images/Obus.png")
    largeurObusImg = obusImg:getWidth()
    hauteurObusImg = obusImg:getHeight()
end

function Hero.Move(dt)
    if love.keyboard.isDown('z') then
        tankHero.x = tankHero.x + vitessex * math.cos(tankHero.angle) * dt
        tankHero.y = tankHero.y + vitessey * math.sin(tankHero.angle) * dt
    end
    if love.keyboard.isDown('s') then
        tankHero.x = tankHero.x - vitessex * math.cos(tankHero.angle) * dt
        tankHero.y = tankHero.y - vitessey * math.sin(tankHero.angle) * dt
    end
    if love.keyboard.isDown('q') then
        tankHero.angle = tankHero.angle - 3 * dt
    end
    if love.keyboard.isDown('d') then
        tankHero.angle = tankHero.angle + 3 * dt
    end

    if tankHero.x + largeurTankHeroImg/2 >= lScreen then
        tankHero.x = lScreen - largeurTankHeroImg/2
    end

    if tankHero.x - largeurTankHeroImg/2 <= 0  then 
        tankHero.x = largeurTankHeroImg/2
    end

    if tankHero.y + hauteurTankHeroImg/2 >= hScreen then
        tankHero.y = hScreen - hauteurTankHeroImg/2
    end

    if tankHero.y - hauteurTankHeroImg/2 <= 0  then 
        tankHero.y = hauteurTankHeroImg/2
    end
end

listObus = {}
function CreerObus(pX, pY, pAngle, pVitesse)
    local Obus = {}
    Obus.x = pX
    Obus.y = pY
    Obus.angle = pAngle
    Obus.vitesse = pVitesse
    table.insert(listObus, Obus)
end

function Hero.Obus(dt)
    local n
    for n=#listObus,1, -1 do
        local o = listObus[n] 
        o.x = o.x + (o.vitesse * dt ) * math.cos(o.angle) 
        o.y = o.y + (o.vitesse * dt ) * math.sin(o.angle) 
        if o.x > lScreen or o.x <0 or o.y> hScreen or o.y<0 then
            table.remove(listObus, n)
        end
    end
end

function Hero.Canon()
    local mousex = love.mouse.getX()
    local mousey = love.mouse.getY()
    angleCanon = math.angle(tankHero.x, tankHero.y, mousex, mousey)
end

function Hero.Hit()
    local no
    for no = #listObusEnnemy, 1, -1 do 
        local o = listObusEnnemy[no]
        local dist = math.dist(tankHero.x, tankHero.y, o.x, o.y)
        if  dist < largeurTankHeroImg/2 then
            table.remove(listObusEnnemy, no)
            HUD.RemoveHeroLife(dt)
        end
    end
end


function Hero.Draw()
    for k,v in ipairs (listObus) do 
        love.graphics.draw(obusImg, v.x, v.y, v.angle, 1/2, 1/2, largeurObusImg/2, hauteurObusImg/2 )
    end
    love.graphics.draw(tankHeroImg, tankHero.x, tankHero.y, tankHero.angle, 1,1,largeurTankHeroImg /2 , hauteurTankHeroImg / 2 )
    love.graphics.draw(canonHeroImg, tankHero.x, tankHero.y, angleCanon, 1,1,largeurCanonHeroImg /2 , hauteurCanonHeroImg / 2 )
    --love.graphics.circle("fill", tankHero.x, tankHero.y, 3 )
    ---love.graphics.rectangle("line", tankHero.x - largeurTankHeroImg/2 , tankHero.y - hauteurTankHeroImg/2,largeurTankHeroImg, hauteurTankHeroImg )
end

function Hero.MouseShootCanon()
    function love.mousepressed(x, y, button)
        x = largeurCanonHeroImg
        y = hauteurCanonHeroImg / 2
        if button == 1 then 
            CreerObus(tankHero.x, tankHero.y, angleCanon, 500)
        end
    end
end

--function Hero.keypressed(key)
    --if hasMissile == true then 
        --if key == " " then 
           --- CreerObus(tankHero.x, tankHero.y, angleCanon, 500)
       -- end
    --end
--end

--function Hero.Shoot(key)
    --if key == "space" then 
        --CreerObus(tankHero.x, tankHero.y, tankHero.angle, 300)
    --end
--end


return Hero