Menu = {}

local carte = require("Menu_Data")

-- Timer pour que "Press Start" clignote
local flash = 2
local timer = flash
local pressStart = true
-- Liste de layers utilisés pour le menu
Layers = {
    background = carte.layers[1].data,
    walls = carte.layers[2].data,
    decor = carte.layers[3].data,
    Animation = carte.layers[4].data
}

function Menu.Load()
    Img_title = love.graphics.newImage("Images/Tank You.png")
    largeurImg_title = love.graphics.getWidth() / 2
    hauteurImg_title = love.graphics.getHeight() / 2

    Img_Press_enter = love.graphics.newImage("Images/PressEntertxt.png")

    Tilesheet = love.graphics.newImage("Images/TileSet1.png")
    Largeurtilesheet = Tilesheet:getWidth()
    HauteurTilesheet = Tilesheet:getHeight()

    local nbcol = Largeurtilesheet / TILE_HEIGHT
    local nbline = HauteurTilesheet / TILE_WIDTH

    TileTextures[0] = nil
    local c, l
    local id = 1
    for l = 1, nbline do
        for c = 1, nbcol do
            TileTextures[id] =
                love.graphics.newQuad(
                (c - 1) * TILE_WIDTH,
                (l - 1) * TILE_HEIGHT,
                TILE_WIDTH,
                TILE_HEIGHT,
                Largeurtilesheet,
                HauteurTilesheet
            )
            id = id + 1
        end
    end
end

function Menu.Update(dt)
    if timer > 1 then
        pressStart = true
        timer = timer - dt
    end
    if timer < 1 then
        timer = timer - dt
        pressStart = false
    end
    if timer <= 0 then
        timer = flash
    end
end

function Menu.Draw()
    AfficheLayers(Layers.background)
    AfficheLayers(Layers.walls)
    AfficheLayers(Layers.decor)

    love.graphics.draw(
        Img_title,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        0,
        1,
        1,
        Img_title:getWidth() / 2,
        Img_title:getHeight() / 2
    )

    if pressStart == true then
        AfficheLayers(Layers.Animation)
        love.graphics.draw(
            Img_Press_enter,
            love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 + hauteurImg_title / 2,
            0,
            1,
            1,
            Img_Press_enter:getWidth() / 2,
            Img_Press_enter:getHeight() / 2
        )
        love.graphics.setColor(1, 1, 1)
    end
end

return Menu
