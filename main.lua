-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

local cartes = require("maps")
local TankJoueur = require("Hero")
local ennemy = require("Ennemies")

function love.load()
    cartes.Load()
    TankJoueur.Load()
    ennemy.Load()
end

function love.update(dt)
    TankJoueur.Move(dt)
    TankJoueur.Canon(dt)
    TankJoueur.Obus(dt)
    ennemy.Timer(dt)
    ennemy.Spawn(dt)

    local n
    for n=#listObus,1,-1 do 
        local o = listObus[n]
        for n= #listTankEnmy, -1, 1 do 
        local t = #listTankEnmy[n]
            if math.dist(o.x, o.y, t.x, t.y) < largeurTankEnemyImg/2 then
              table.remove(listTankEnmy, t)
             table.remove(listObus, o)
            end
        end
    end

    
end

function love.draw()
    cartes.draw()
    TankJoueur.Draw() 
    ennemy.Draw()
end

function love.keypressed(key)
    TankJoueur.Shoot(key)
end
