-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

local Menu = require("Menu")
local cartes = require("maps")
local TankJoueur = require("Hero")
local ennemy = require("Ennemies")
local Weapons = require("Weapons")
local HUD = require ("HUD")
local loot = require("Loot")

GameState = {}
GameState.Menu = "MENU"
GameState.level1 = "LEVEL1"
GameState.Boss = "BOSS"
GameState.Pause = "PAUSE"
GameState.Inventaire = "INVENTAIRE"
GameState.GameOver = "GAMEOVER"
GameState.Quit = "QUIT"


GameState = GameState.Menu

function love.load()
   -- love.window.setMode(1024,700)
    cartes.Load()
    TankJoueur.Load()
    ennemy.Load()
    Menu.Load()
end

function UpdateMenu(dt)
    Menu.Update(dt)
end

function UpdateLevel1(dt)
    TankJoueur.Move(dt)
    TankJoueur.Canon(dt)
    TankJoueur.MouseShootCanon()
    TankJoueur.IsHit(dt)

    ennemy.Spawn(dt)
    ennemy.IsHit(dt)
    ennemy.IsHitHeavy(dt)
    
    Weapons.Obus(dt)
    Weapons.EMI(dt)
end

function UpdatePause()
end

function UpdateBoss()
end

function UpdateInventaire()
end

function UpdateGameOver()
end

function love.update(dt)
    if GameState == "MENU" then 
        UpdateMenu(dt)
    elseif GameState == "LEVEL1" then
        UpdateLevel1(dt)
    elseif GameState == "INVENTAIRE" then
        UpdateInventaire(dt) 
    end
end

function DrawMenu()
    Menu.Draw()
end

function DrawLevel1()
    cartes.draw()
    TankJoueur.Draw() 
    ennemy.Draw()
    HUD.Draw()
    loot.Draw()
    Weapons.Draw()
end

function DrawInventaire()
    love.graphics.print("INVENTAIRE", lScreen/2, hScreen/2)
end


function DrawBoss()
end

function DrawGameOver()
    love.graphics.print("GAMEOVER", lScreen/2, hScreen/2)
end


function love.draw()
    if GameState == "MENU" then 
        DrawMenu()
    elseif GameState == "LEVEL1" then
       DrawLevel1()
    elseif GameState == "PAUSE" then
        DrawLevel1()
    elseif GameState == "BOSS" then
        DrawLevel1()
    elseif GameState == "INVENTAIRE" then
        DrawInventaire()
    elseif GameState == "GAMEOVER" then
        DrawGameOver()
    end
end

function love.keypressed(key)
    if GameState == "MENU" then
        if key == "return" then
            GameState = "LEVEL1"
        end
    elseif GameState == "LEVEL1" then
        if key == "p" then
            GameState = "PAUSE"
        end

        if key == "i" then
            GameState = "INVENTAIRE"
        end

        if key == "t" then
            Weapons.Type()
        end

    elseif GameState == "PAUSE" then
        if key == "p" then
            GameState = "LEVEL1"
        end
    
    elseif GameState == "INVENTAIRE" then
        if key == "i" then
            GameState = "LEVEL1"
        end
     
    elseif GameState == "LEVEL1" then
        if key == "escape" then
            GameState = "QUIT"
        end
    
    elseif GameState == "GAMEOVER" then
        if key == "return" then 
            GameState = "MENU"
        end
    end
    
end
