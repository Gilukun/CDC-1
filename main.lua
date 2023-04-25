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
local weaponHero = require("WeaponsHero")
local HUD = require ("HUD")
local loot = require("Loot")



function love.load()
    love.window.setMode(1024,700)
    cartes.Load()
    TankJoueur.Load()
    ennemy.Load()
end

function love.update(dt)
    TankJoueur.Move(dt)
    TankJoueur.Canon(dt)
    TankJoueur.Obus(dt)
    TankJoueur.Canon(dt)
    TankJoueur.MouseShootCanon(dt)
    ennemy.Spawn(dt)
    ennemy.Dead()
    loot.DropLoot()
end

function love.draw()
    cartes.draw()
    TankJoueur.Draw() 
    ennemy.Draw()
    HUD.Draw()
    loot.Draw()
end

--function love.keypressed(key)
    --TankJoueur.Shoot(key)
-- end
