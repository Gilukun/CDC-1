-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- LOVE2D functions
function math.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end
function math.dist(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end
function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

local Menu = require("Menu")
local Cartes = require("Maps")
local Player = require("Hero")
local Ennemy = require("Ennemies")
local Weapons = require("Weapons")
local GUI = require("GUI")
local Loot = require("Loot")
local Pause = require("Pause")
local GameOver = require("GameOver")
local Sounds = require("Sounds")

-- ETATS DU JEU
GameState = {}
GameState.Menu = "MENU"
GameState.level1 = "LEVEL1"
GameState.Boss = "BOSS"
GameState.Pause = "PAUSE"
GameState.Inventaire = "INVENTAIRE"
GameState.GameOver = "GAMEOVER"
GameState.Quit = "QUIT"

G_State = GameState.Menu

function love.load()
    love.window.setMode(1024, 1024)
    Menu.Load()
    Cartes.Load()
    Player.Load()
    --Player.Start()
    Ennemy.Load()
    Pause.Load()
    GameOver.Load()
    Loot.Load()
    GUI.Load()
    Sounds.Load()
end

function UpdateMenu(dt)
    Menu.Update(dt)
end

function UpdateLevel1(dt)
    Cartes.Update(dt)

    Player.Move(dt)
    Player.MouseShootCanon()

    Ennemy.Update(dt)

    Weapons.Obus(dt)
    Weapons.EMI(dt)
    Weapons.Shield(dt)
end

function UpdatePause()
end

function UpdateBoss()
end

function UpdateInventaire()
end

function UpdateGameOver(dt)
    GameOver.Update(dt)
end

function love.update(dt)
    if G_State == GameState.Menu then
        UpdateMenu(dt)
    elseif G_State == GameState.level1 then
        UpdateLevel1(dt)
    elseif G_State == GameState.GameOver then
        UpdateGameOver(dt)
    end
end

function DrawMenu()
    Menu.Draw()
end

function DrawLevel1()
    Cartes.draw()
    Player.Draw()
    Ennemy.Draw()
    Loot.Draw()
    Weapons.Draw()
    GUI.Draw()
end

function DrawInventaire()
    love.graphics.print("INVENTAIRE", lScreen / 2, hScreen / 2)
end

function DrawBoss()
end

function DrawGameOver()
    GameOver.Draw()
end

function DrawPause()
    Pause.Draw()
end

function love.draw()
    if G_State == GameState.Menu then
        DrawMenu()
    elseif G_State == GameState.level1 then
        DrawLevel1()
    elseif G_State == GameState.Pause then
        DrawLevel1()
        DrawPause()
    elseif G_State == GameState.Boss then
        DrawLevel1()
    elseif G_State == GameState.Inventaire then
        DrawInventaire()
    elseif G_State == GameState.GameOver then
        DrawLevel1()
        DrawGameOver()
    end
end

function love.keypressed(key)
    if G_State == GameState.Menu then
        if key == "return" then
            Player.Start()
            Ennemy.Start()
            Weapons.Start()
            Loot.Start()
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
        if ShieldActiveWidth >= 50 then
            if key == "b" then
                Weapons.Type(W_Style.SHIELD)
                Sd_Shield:play()
            end
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
            G_State = GameState.level1
        end
    elseif G_State == GameState.GameOver then
        if key == "return" then
            G_State = GameState.Menu
        end
    end
end

function love.mouse.setVisible()
end
