local Maps = {}

local tiled = require("Maps_data")

MAP_WIDTH = 32 -- nombre de colonne
MAP_HEIGHT = 20 -- nombre de ligne
TILE_WIDTH = 32 -- largeur de la tile
TILE_HEIGHT = 32 -- Hauteur de la tile

background = tiled.layers[1].data
trees1 = tiled.layers[2].data
floor = tiled.layers[3].data
Shadow = tiled.layers[4].data
Grass = tiled.layers[5].data
Cimetery = tiled.layers[6].data
Cimetery2 = tiled.layers[7].data
Walls = tiled.layers[8].data
Trees2 = tiled.layers[9].data
Deco = tiled.layers[10].data
Animations = tiled.layers[11].data
Items = tiled.layers[11].data

Tilesheet = {}
TileTextures = {}

TileTypes = {}
TileTypes[1] = "grass"
TileTypes[650] = "Wall"

local flash = 2
local timer = flash
local flashDecor = true

local flash2 = 3
local timer2 = flash2
local flashDecor3 = true

local flash3 = 1.5
local timer3 = flash3
local flashDecor3 = true

function Maps.Load()
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

function Maps.Update(dt)
  if timer > 1 then
    flashDecor = true
    timer = timer - dt
  end
  if timer < 1 then
    timer = timer - dt
    flashDecor = false
  end
  if timer <= 0 then
    timer = flash
  end

  if timer2 > 1 then
    flashDecor2 = true
    timer2 = timer2 - dt
  end
  if timer2 < 1 then
    timer2 = timer2 - dt
    flashDecor2 = false
  end
  if timer2 <= 0 then
    timer2 = flash2
  end

  if timer3 > 1 then
    flashDecor = true
    timer = timer - dt
  end
  if timer3 < 1 then
    timer3 = timer3 - dt
    flashDecor3 = false
  end
  if timer3 <= 0 then
    timer3 = flash3
  end
end

function Maps.draw()
  local nbligne = #background / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = background[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end
  local nbligne = #trees1 / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = trees1[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end
  local nbligne = #floor / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = floor[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end
  local nbligne = #Shadow / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = Shadow[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end
  local nbligne = #Grass / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = Grass[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end
  local nbligne = #Cimetery / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = Cimetery[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end

  local nbligne = #Walls / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = Walls[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end

  local nbligne = #Trees2 / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = Trees2[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end

  local nbligne = #Deco / TILE_WIDTH
  local nbcol = TILE_HEIGHT
  local l, c
  for l = nbligne, 1, -1 do
    for c = 1, nbcol do
      local tuile = Deco[((l - 1) * TILE_WIDTH) + c]
      if tuile > 0 then
        love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
      end
    end
  end

  if flashDecor3 == true then
    local nbligne = #Animations / TILE_WIDTH
    local nbcol = TILE_HEIGHT
    local l, c
    for l = nbligne, 1, -1 do
      for c = 1, nbcol do
        local tuile = Animations[((l - 1) * TILE_WIDTH) + c]
        if tuile > 0 then
          love.graphics.draw(Tilesheet, TileTextures[tuile], (c - 1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
        end
      end
    end
  end

  -- local x = love.mouse.getX()
  ---local  y = love.mouse.getY()
  --- local col = math.floor(x / TILE_WIDTH) + 1
  --local lig = math.floor(y / TILE_HEIGHT) + 1

  -- if col > 0 and col<= MAP_WIDTH and lig> 0 and lig <= MAP_WIDTH then
  -- local id = Maps.background[lig][col]
  -- love.graphics.print("id=" .. tostring(Maps.TileTypes[id]))
  --- end
end

return Maps
