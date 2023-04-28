Weapons = {}

NomObusHero = "HERO"
NomObusEnnemy = "ENNEMY"

listObus = {}
function Weapons.CreerObus(pNom, pX, pY, pAngle, pVitesse)
    local Obus = {}
    Obus.nom = pNom
    Obus.x = pX
    Obus.y = pY
    Obus.angle = pAngle
    Obus.vitesse = pVitesse
    table.insert(listObus, Obus)
end

function Weapons.Obus(dt)
    local n
    for n=#listObus,1, -1 do
        local o = listObus[n] 
        o.x = o.x + (o.vitesse * dt ) * math.cos(o.angle) 
        o.y = o.y + (o.vitesse * dt ) * math.sin(o.angle) 
        if o.x > lScreen or o.x <0 or o.y> hScreen or o.y<0 then
            table.remove(listObus, n)
        end
    end
end

return Weapons