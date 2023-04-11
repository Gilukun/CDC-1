-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

local cartes = require("maps")

local tank={}
tank.x = 200
tank.y = 200
tank.vx = 0
tank.vy = 0
tank.angle = 0

local tankE = {}
tankE.x = 0
tankE.y = 0 
tankE.vx = 10
tankE.vy = 10
tankE.angle= 0

local ObusH = {}
ObusH.x = 0
ObusH.y = 0
ObusH.vx = 0
ObusH.vy = 0


function love.load()
    love.window.setMode(1024,1080)

    lScreen = love.graphics.getWidth()
    hScreen = love.graphics.getHeight()
    
    tankH = love.graphics.newImage("Tank.png")
    canonH = love.graphics.newImage("Canon.png")
    tankE = love.graphics.newImage("BadTank.png")
    background = love.graphics.newImage("background.png")
    obusH = love.graphics.newImage("Obus.png") 

    LargeurTankH = tankH:getWidth()
    HauteurTankH = tankH:getHeight()
    
    cartes.Load()
    

end

function love.update(dt)
    if love.keyboard.isDown("q") then
        tank.angle = tank.angle - 1 * dt
    elseif love.keyboard.isDown("d") then
        tank.angle = tank.angle + 1 * dt
    end
    if love.keyboard.isDown("z") then
        local vx = 50 * math.cos(tank.angle)
        local vy = 50 * math.sin(tank.angle)
        tank.x = tank.x + vx * dt
        tank.y = tank.y + vy * dt
    end
    if love.keyboard.isDown("s") then
        local vx = 50 * math.cos(tank.angle)
        local vy = 50 * math.sin(tank.angle)
        tank.x = tank.x - vx * dt
        tank.y = tank.y - vy * dt
    end

    -- le cannon suit la souri
    local mousex = love.mouse.getX()
    local mousey = love.mouse.getY()
    angleCanon = math.angle(tank.x, tank.y, mousex, mousey)

end

function love.draw()
    -- love.graphics.draw(background)
    cartes.draw()

    love.graphics.draw(tankH, tank.x, tank.y, tank.angle, 1, 1, LargeurTankH/2, HauteurTankH/2)
    love.graphics.draw(canonH, tank.x, tank.y, angleCanon, 1, 1, LargeurTankH/2, HauteurTankH/2)
    -- love.graphics.draw(obusH, tank.x, tank.y, 0, 1, 1, LargeurTankH/2, HauteurTankH/2)
    love.graphics.draw(tankE, 200, 200)
    cartes.draw()
end

function love.keypressed(key)
    if key == "mouseRight" then
    end

end
