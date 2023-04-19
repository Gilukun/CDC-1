if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")

Hero = {}

local tankHero = {}
tankHero.x = 200
tankHero.y = 200
tankHero.vx = 0
tankHero.vy = 0
tankHero.angle = 0

listObus = {}

function CreerObus(pX, pY, pAngle, pVitesse)
    local Obus = {}
    Obus.x = pX
    Obus.y = pY
    Obus.angle = pAngle
    Obus.vitesse = pVitesse
    table.insert(listObus, Obus)
end

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
    local vitessex = 100 * math.cos(tankHero.angle) * dt
    local vitessey = 100 * math.sin(tankHero.angle) * dt

    if love.keyboard.isDown('up') then
        tankHero.x = tankHero.x + vitessex
        tankHero.y = tankHero.y + vitessey
    end
    if love.keyboard.isDown('down') then
        tankHero.x = tankHero.x - vitessex
        tankHero.y = tankHero.y - vitessey
    end
    if love.keyboard.isDown('left') then
        tankHero.angle = tankHero.angle - 1 * dt
    end
    if love.keyboard.isDown('right') then
        tankHero.angle = tankHero.angle + 1 * dt
    end
end

function Hero.Canon()
    local mousex = love.mouse.getX()
    local mousey = love.mouse.getY()
    angleCanon = math.angle(tankHero.x, tankHero.y, mousex, mousey)
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


function Hero.Draw()
    for k,v in ipairs (listObus) do 
        love.graphics.draw(obusImg, v.x, v.y, v.angle, 1/2, 1/2, largeurObusImg/2, hauteurObusImg/2 )
    end
    love.graphics.draw(tankHeroImg, tankHero.x, tankHero.y, tankHero.angle, 1,1,largeurTankHeroImg /2 , hauteurTankHeroImg / 2 )
    love.graphics.draw(canonHeroImg, tankHero.x, tankHero.y, tankHero.angle, 1,1,largeurCanonHeroImg /2 , hauteurCanonHeroImg / 2 )
end

function Hero.Shoot(key)
    if key == "space" then 
        CreerObus(tankHero.x, tankHero.y, tankHero.angle, 300)
    end
end

return Hero