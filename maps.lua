local Maps={}

Maps.cartes = {}
Maps.cartes.background = {
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

Maps.cartes.MAP_WIDTH= 32 -- nombre de colonne
Maps.cartes.MAP_HEIGHT = 23 -- nombre de ligne
Maps.cartes.TILE_WIDTH= 32 -- largeur de la tile
Maps.cartes.TILE_HEIGHT = 32 -- Hauteur de la tile

Maps.Tilesheet = {}
Maps.TileTextures = {}
Maps.TileTypes= {}
Maps.TileTypes[1] = "grass"
Maps.TileTypes[169] = "Road"

function Maps.Load()
    Maps.Tilesheet = love.graphics.newImage("TileSet.png")
    Largeurtilesheet = Maps.Tilesheet:getWidth()
    HauteurTilesheet = Maps.Tilesheet:getHeight()

    local nbcol = Largeurtilesheet/ Maps.cartes.TILE_WIDTH
    local nbline = HauteurTilesheet/ Maps.cartes.TILE_HEIGHT

    Maps.TileTextures[0] = nil 

    local c,l
    local id = 1
    for l = 1, nbline do 
        for c = 1, ncol do
            Maps.TileTextures[id] = love.graphics.newQuad( (c-1)* Maps.cartes.TILE_WIDTH, (l-1) * Maps.cartes.TILE_HEIGHT, Maps.cartes.TILE_WIDTH, Maps.cartes.TILE_HEIGHT, Largeurtilesheet, HauteurTilesheet)
           id = id + 1
        end
    end
end

function Maps.Udpate(dt)
end

function Maps.draw()
    local l,c
    local CaseNb = 0
    for l= 1, Maps.cartes.MAP_HEIGHT do 
        for c = 1, Maps.cartes.MAP_WIDTH do 
            local id = Maps.cartes.background[l][c]
            local textures = Maps.TileTextures[id]
            CaseNb = CaseNb + 1
            if textures~= nil then 
                love.graphics.draw(Maps.Tilesheet, textures,(c-1) * Maps.cartes.TILE_WIDTH, (l - 1) * Maps.cartes.TILE_HEIGHT)
                love.graphics.print(tostring(Maps.TileTypes),(c-1) * Maps.cartes.TILE_WIDTH, (l - 1) * Maps.cartes.TILE_HEIGHT)
            end
        end
    end

    local x = love.mouse.getX()
    local  y = love.mouse.getY()
    local col = math.floor(x / Maps.cartes.TILE_WIDTH) + 1  -- on rajoute 1 pour avoir le bon indice de colonne (math.floor prend l'arrondie inférieur donc pour la première colonne ça fera 0 au lieux de 1)
    local lig = math.floor(y / Maps.cartes.TILE_HEIGHT) + 1
    
    if col > 0 and col<= Maps.cartes.MAP_WIDTH and lig> 0 and lig <= Maps.cartes.MAP_WIDTH then
        local id = Maps.cartes.background[lig][col]
        love.graphics.print("id=" .. tostring(Maps.TileTypes[id]))
    end

end


return Maps