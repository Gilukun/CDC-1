-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

local cartes = require("maps")
local heros = require("Hero")
local ennemy = require("Ennemies")

function love.load()
    love.window.setMode(1200,600)    
    cartes.Load()
    heros.Load()
    ennemy.Load()
end

function love.update(dt)
    heros.Update(dt)
    ennemy.Update(dt)
end

function love.draw()
    cartes.draw()
    heros.Draw() 
    ennemy.Draw()
end

function love.keypressed(key)
    heros.keypressed(key)
end
