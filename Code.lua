function CreerEnnemy(pNom, pX, pY, pVitesse, pAngle, pLife, pEtat, pDist)
    local tank_E = {}
    tank_E.nom = pNom
    tank_E.x = 0
    tank_E.y = 
    tank_E.vitesse = 100
    tank_E.angle = 0
    tank_E.life = 5
    tank_E.etat = ET_Tank_E.ETAT_IDLE
    tank_E.dist = 0
    tank_E.IsAlive = true
    table.insert(list_tank_E, tank_E)


timer_Spawn = timer_Spawn - dt
    if timer_Spawn <= 0 then
        CreerEnnemy()
        timer_Spawn = E_SPAWN_T
    -- spawnSFX:play()
    end

    local n
    for n = #list_tank_E, 1, -1 do
        local t = list_tank_E[n]
        chase_Dist = 200
        shoot_Dist = 200
        col_Dist = 90
        t.dist = math.dist(t.x, t.y, Player.x, Player.y)

        if t.etat == ET_Tank_E.ETAT_IDLE then
            t.etat = ET_Tank_E.ETAT_MOVE
        elseif t.etat == ET_Tank_E.ETAT_MOVE then
            local oldtx = t.x
            local oldty = t.y

            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt

            for k, v in ipairs(list_tank_E) do
                local oldvx = v.x
                local oldvy = v.y
                if v ~= t then
                    if math.dist(v.x, v.y, t.x, t.y) < largeurImg_tank_E then
                        v.x = oldvx
                        v.y = oldvy
                        t.x = oldtx
                        t.y = oldty
                    end
                end
            end

            if t.life <= 0 then
                t.IsAlive = false
                t.etat = ET_Tank_E.ETAT_DEAD
            end

            if t.dist <= chase_Dist then
                t.etat = ET_Tank_E.ETAT_CHASE
                oldangle = t.angle
            end
        elseif t.etat == ET_Tank_E.ETAT_CHASE then
            local oldtx = t.x
            local oldty = t.y

            t.angle = math.angle(t.x, t.y, Player.x, Player.y)
            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt

            for k, v in ipairs(list_tank_E) do
                local oldvx = v.x
                local oldvy = v.y
                if v ~= t then
                    if math.dist(v.x, v.y, t.x, t.y) < largeurImg_tank_E then
                        v.x = oldvx
                        v.y = oldvy
                        t.x = oldtx
                        t.y = oldty
                    end
                end
            end

            if t.dist >= chase_Dist then
                t.etat = ET_Tank_E.ETAT_MOVE
                t.angle = oldangle
            end

            if t.dist <= shoot_Dist then
                t.etat = ET_Tank_E.ETAT_SHOOT
            end

            if t.life <= 0 then
                t.IsAlive = false
                t.etat = ET_Tank_E.ETAT_DEAD
            end
        elseif t.etat == ET_Tank_E.ETAT_SHOOT then
            local oldtx = t.x
            local oldty = t.y

            t.angle = math.angle(t.x, t.y, Player.x, Player.y)
            t.x = t.x + t.vitesse * math.cos(t.angle) * dt
            t.y = t.y + t.vitesse * math.sin(t.angle) * dt

            for k, v in ipairs(list_tank_E) do
                local oldvx = v.x
                local oldvy = v.y
                if v ~= t then
                    if math.dist(v.x, v.y, t.x, t.y) < largeurImg_tank_E then
                        v.x = oldvx
                        v.y = oldvy
                        t.x = oldtx
                        t.y = oldty
                    end
                end
            end
            timer_Shoot = timer_Shoot - dt
            if timer_Shoot < 0 then
                Weapons.CreerObus(NomObusEnnemy, t.x, t.y, t.angle, 500)
                timer_Shoot = E_SHOOT
            end

            if t.dist <= col_Dist then
                t.etat = ET_Tank_E.ETAT_COLLISION
            end
        elseif t.etat == ET_Tank_E.ETAT_COLLISION then
            t.angle = math.angle(t.x, t.y, Player.x, Player.y)
            timer_Shoot = timer_Shoot - dt
            if timer_Shoot < 0 then
                Weapons.CreerObus(NomObusEnnemy, t.x, t.y, t.angle, 500)
                timer_Shoot = E_SHOOT
            end

            if t.dist >= col_Dist then
                t.etat = ET_Tank_E.ETAT_CHASE
            end
        elseif t.etat == ET_Tank_E.ETAT_DEAD then
            t.IsAlive = false
        end

        -- Suppression des tanks hors de l'écran
        if t.x > lScreen then
            table.remove(list_tank_E, n)
        end
end


-------------

local Maps = {}

local tiled = require("Maps_data")

MAP_WIDTH = 32 -- nombre de colonne
MAP_HEIGHT = 20 -- nombre de ligne
TILE_WIDTH = 32 -- largeur de la tile
TILE_HEIGHT = 32 -- Hauteur de la tile

list_Layers = {}
list_Layers.background = tiled.layers[1].data
list_Layers.trees1 = tiled.layers[2].data
list_Layers.floor = tiled.layers[3].data
list_Layers.Shadow = tiled.layers[4].data
list_Layers.Grass = tiled.layers[5].data
list_Layers.Cimetery = tiled.layers[6].data
list_Layers.Cimetery2 = tiled.layers[7].data
list_Layers.Walls = tiled.layers[8].data
list_Layers.Trees2 = tiled.layers[9].data
list_Layers.Deco = tiled.layers[10].data
list_Layers.Animations = tiled.layers[11].data
list_Layers.Items = tiled.layers[11].data

Tilesheet = {}
TileTextures = {}

TileTypes = {}
TileTypes[1] = "grass"
TileTypes[650] = "Wall"

local flash = 2
local timer = flash
local flashDecor = true

local keys = {}
function GetKeys(list)
  for k, v in pairs(list) do
      keys[#keys+1] = k
  end
  return keys
end

GetKeys(list_layers)


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
end

function Maps.draw()

    


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


  