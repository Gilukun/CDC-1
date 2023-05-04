local Maps={}

local tiled = require("Map_Data")

MAP_WIDTH= 32 -- nombre de colonne
MAP_HEIGHT = 20 -- nombre de ligne
TILE_WIDTH= 32 -- largeur de la tile
TILE_HEIGHT = 32 -- Hauteur de la tile

background = tiled.layers[1].data
decor = tiled.layers[2].data

Tilesheet = {}
TileTextures = {}

TileTypes= {}
TileTypes[1] = "grass"
TileTypes[650] = "Wall"

function Maps.IsSolid(pid)
  local tiletype = TileTypes[pid]
  if tiletype == "Wall" then 
    return true
  end
  return false
end

function Maps.Load()
    Tilesheet = love.graphics.newImage("Images/tileset2.png")
    Largeurtilesheet = Tilesheet:getWidth()
    HauteurTilesheet = Tilesheet:getHeight()

    local nbcol = Largeurtilesheet / TILE_HEIGHT
    local nbline =  HauteurTilesheet / TILE_WIDTH

    TileTextures[0] = nil 
    local c,l
    local id = 1
    for l = 1, nbline do 
        for c = 1, nbcol do
            TileTextures[id] = love.graphics.newQuad( (c-1)* TILE_WIDTH, (l-1) * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT, Largeurtilesheet, HauteurTilesheet)
           id = id + 1
        end
    end
end


function Maps.draw()
    local nbligne = #background/TILE_WIDTH
    local nbcol = TILE_HEIGHT 
    local l,c
    for l = nbligne, 1, -1 do 
      for c = 1, nbcol do 
        local tuile = background[((l-1)* TILE_WIDTH) + c]
          if tuile > 0 then 
            love.graphics.draw(Tilesheet, TileTextures[tuile],(c-1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
          end 
      end  
    end

    local nbligne = #decor/TILE_WIDTH
    local nbcol = TILE_HEIGHT 
    local l,c
    for l= nbligne, 1, -1 do 
      for c = 1, nbcol do 
        local tuile = decor[((l-1)* TILE_HEIGHT) + c]
          if tuile > 0 then 
            love.graphics.draw(Tilesheet, TileTextures[tuile],(c-1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
            love.graphics.print(tuile,(c-1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT )
            love.graphics.rectangle("line",(c-1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT)
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