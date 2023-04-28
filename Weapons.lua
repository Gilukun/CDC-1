Weapons = {}

NomObusHero = "HERO"
NomObusEnnemy = "ENNEMY"

W_Types = {}
W_Types.Basic = "CANON"
W_Types.Heavy = "MISSILE"

WeaponTypes = W_Types.Basic

EMI_Duration = 3
EMI_Timer = EMI_Duration
EMI_Radius = 0
EMI_Radius_Init = EMI_Radius

function Weapons.Type()
    if WeaponTypes == W_Types.Basic then 
        WeaponTypes = W_Types.Heavy
    end
end

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

function timer(pState, pStateA, pStateB, ptimer, pDuration, pDelta)
    if pState == pStateA then 
        if ptimer >= 0 then 
            ptimer = ptimer - pDelta
        end
        if ptimer <= 0 then 
            pState = pStateB
            ptimer = pDuration
        end
    end
end
function Weapons.EMI(dt)
    if WeaponTypes == W_Types.Heavy then 
        if EMI_Timer >= 0 then 
            EMI_Timer = EMI_Timer - dt
            EMI_Radius_Init = EMI_Radius_Init + 50 * dt
        end
        if EMI_Timer <= 0 then 
            WeaponTypes = W_Types.Basic
            EMI_Timer = EMI_Duration
            EMI_Radius_Init = EMI_Radius
        end
    end
    -- timer(WeaponTypes, W_Types.Heavy, W_Types.Basic, EMI_Timer, EMI_Duration, dt)
end

function Weapons.Draw()
    love.graphics.print(tostring(EMI_Radius_Init), 100, 200)
    if WeaponTypes == W_Types.Heavy then
        love.graphics.setColor(love.math.colorFromBytes(158, 26, 11, 100))
        love.graphics.circle("fill", tankHero.x, tankHero.y,EMI_Radius_Init)
        love.graphics.setColor(1,1,1,1)
    end
end

return Weapons