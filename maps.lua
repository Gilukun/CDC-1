local Maps={}

local MAP_WIDTH= 32 -- nombre de colonne
local MAP_HEIGHT = 23 -- nombre de ligne
local TILE_WIDTH= 32 -- largeur de la tile
local TILE_HEIGHT = 32 -- Hauteur de la tile

Maps.background = { 
    {1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {169, 169, 169, 169, 169, 169, 169, 169, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 212, 169, 169, 169, 169, 169, 169, 169, 169, 212, 169},
    {169, 169, 169, 169, 254, 169, 169, 169, 169, 169, 169, 169, 169, 254, 169, 169, 169, 169, 169, 169, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 254, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {169, 296, 169, 169, 169, 169, 169, 295, 169, 169, 254, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 169, 216, 169, 169, 169, 169, 169, 169, 169, 169, 169},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 296, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 296, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1, 169, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
}



Maps.Tilesheet = {}
Maps.TileTextures = {}

Maps.TileTypes= {}
Maps.TileTypes[1] = "grass"
Maps.TileTypes[169] = "Road"

function Maps.Load()
    Maps.TilesheetBack = love.graphics.newImage("Images/TileSet.png")
    Largeurtilesheet = Maps.TilesheetBack:getWidth()
    HauteurTilesheet = Maps.TilesheetBack:getHeight()

    local nbcol = Largeurtilesheet / TILE_WIDTH
    local nbline = HauteurTilesheet/ TILE_HEIGHT

    Maps.TileTextures[0] = nil 

    local c,l
    local id = 1
    for l = 1, nbline do 
        for c = 1, nbcol do
            Maps.TileTextures[id] = love.graphics.newQuad( (c-1)* TILE_WIDTH, (l-1) * TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT, Largeurtilesheet, HauteurTilesheet)
           id = id + 1
        end
    end
end


function Maps.draw()
    local l,c
    local CaseNb = 0
    for l= 1, MAP_HEIGHT do 
        for c = 1, MAP_WIDTH do 
            CaseNb = CaseNb + 1
            local id = Maps.background[l][c]
            local textures = Maps.TileTextures[id]
            if textures~= nil then 
                love.graphics.draw(Maps.TilesheetBack, textures,(c-1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
               --  love.graphics.print(tostring(CaseNb),(c-1) * TILE_WIDTH, (l - 1) * TILE_HEIGHT)
            end
        end
    end

    local x = love.mouse.getX()
    local  y = love.mouse.getY()
    local col = math.floor(x / TILE_WIDTH) + 1
    local lig = math.floor(y / TILE_HEIGHT) + 1
    
    -- if col > 0 and col<= MAP_WIDTH and lig> 0 and lig <= MAP_WIDTH then
       -- local id = Maps.background[lig][col]
        --love.graphics.print("id=" .. tostring(Maps.TileTypes[id]))
    --end

end


return Maps
