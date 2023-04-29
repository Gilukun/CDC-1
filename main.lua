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
GameState.Inventaire = "PAUSE"
GameState.GameOver = "GAMEOVER"
GameState.Quit = "QUIT"


G_State = GameState.Menu

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
    Weapons.Shield(dt)

    HUD.Updates(dt)
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
    if G_State == GameState.Menu then 
        UpdateMenu(dt)
    elseif G_State == GameState.level1 then
        UpdateLevel1(dt)
    elseif G_State ==GameState.Inventaire  then
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
    love.graphics.print(GameState.GameOver, lScreen/2, hScreen/2)
end


function love.draw()
    if G_State == GameState.Menu then 
        DrawMenu()
    elseif G_State == GameState.level1 then
       DrawLevel1()
    elseif G_State == GameState.Pause then
        DrawLevel1()
    elseif G_State == GameState.Boss then
        DrawLevel1()
    elseif G_State == GameState.Inventaire  then
        DrawInventaire()
    elseif G_State == GameState.GameOver then
        DrawGameOver()
    end
end

function love.keypressed(key)
    if G_State == GameState.Menu then
        if key == "return" then
            G_State = GameState.level1
        end
    elseif G_State == GameState.level1 then
        if key == "p" then
            G_State = GameState.Pause
        end

        if key == "i" then
            G_State = GameState.Inventaire 
        end

        if key == "t" then
            Weapons.Type(W_Style.ATTACK)
        end
        if key == "b" then
            Weapons.Type(W_Style.SHIELD)
        end

        if key == "escape" then
            G_State = GameState.Menu
        end

    elseif G_State == GameState.Pause then
        if key == "p" then
            G_State = GameState.level1
        end
    
    elseif G_State == GameState.Inventaire then
        if key == "i" then
            G_State = GameState.Inventaire
        end
    
    elseif G_State == GameState.GameOver then
        if key == "return" then 
            G_State = GameState.Menu
        end
    end
    
end
