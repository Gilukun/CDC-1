Sounds = {}

function Sounds.Load()
    Sd_Menu = love.audio.newSource("Sounds/MENU.mp3", "static")
    Sd_Lvl1 = love.audio.newSource("Sounds/Lvl1.mp3", "static")
    Sd_TANK = love.audio.newSource("Sounds/TANK.mp3", "static")
    Sd_SHOOT = love.audio.newSource("Sounds/SHOOT.wav", "static")
    Sd_TOWER = love.audio.newSource("Sounds/TOWER.wav", "static")

    Sd_DEAD = love.audio.newSource("Sounds/DEAD.mp3", "static")
    Sd_GAMEOVER = love.audio.newSource("Sounds/GAMEOVER.mp3", "static")

    Sd_Shield = love.audio.newSource("Sounds/Shield.wav", "static")
end

return Sounds
