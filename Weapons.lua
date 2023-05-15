Weapons = {}

NomObus = {}
NomObus.Hero = "HERO"
NomObus.Ennemis = "ENNEMY"
NomObus.LaserTower = "LASER"

W_Types = {}
W_Types.Basic = "CANON"
W_Types.Heavy = "MISSILE"
W_Types.Shield = "BOUCLIER"

WeaponTypes = W_Types.Basic

W_Style = {}
W_Style.ATTACK = "ATTAQUE"
W_Style.SHIELD = "BOUCLIER"

-- Super Pouvoir
EMI_Duration = 1
EMI_Timer = EMI_Duration
EMI_Radius = 0
EMI_Radius_Init = EMI_Radius
EMI_ON = false

-- Bouclier
Shield_Duration = 5
Shield_Timer = Shield_Duration
Shield_Radius = 50
Shield_ON = false

function Weapons.Type(pNom)
    if pNom == W_Style.ATTACK then
        if WeaponTypes == W_Types.Basic then
            WeaponTypes = W_Types.Heavy
        end
    end

    if pNom == W_Style.SHIELD then
        if WeaponTypes == W_Types.Basic then
            WeaponTypes = W_Types.Shield
        end
    end
end

function Weapons.Start()
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
        for n = #listObus, 1, -1 do
            local o = listObus[n]
            o.x = o.x + (o.vitesse * dt) * math.cos(o.angle)
            o.y = o.y + (o.vitesse * dt) * math.sin(o.angle)
            if o.x > lScreen or o.x < 0 or o.y > hScreen or o.y < 0 then
                table.remove(listObus, n)
            end
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
        EMI_ON = true
        if EMI_Timer >= 0 then
            EMI_Timer = EMI_Timer - dt
            EMI_Radius_Init = EMI_Radius_Init + 500 * dt
            if EMI_Radius_Init >= 100 then
                EMI_Radius_Init = 100
            end
        end
        if EMI_Timer <= 0 then
            WeaponTypes = W_Types.Basic
            EMI_Timer = EMI_Duration
            EMI_Radius_Init = EMI_Radius
            EMI_ON = false
        end
    end
end

function Weapons.Load()
    Sd_Shield = love.audio.newSource("Sounds/Shield.wav", "static")
    Img_Laser = love.graphics.newImage("Images/Vortex.png")
    largeurImg_Laser = Img_Laser:getWidth()
    hauteurImg_Laser = Img_Laser:getHeight()
end

function Weapons.Shield(dt)
    if WeaponTypes == W_Types.Shield then
        if Shield_Timer >= 0 then
            Shield_Timer = Shield_Timer - dt
            Shield_ON = true
        end

        if Shield_Timer <= 0 then
            WeaponTypes = W_Types.Basic
            Shield_Timer = Shield_Duration
            ShieldActiveWidth = 0
            Shield_ON = false
        end
    end
end

function Weapons.Draw()
    if WeaponTypes == W_Types.Heavy then
        love.graphics.setColor(love.math.colorFromBytes(158, 26, 11, 100))
        love.graphics.circle("fill", Player.x, Player.y, EMI_Radius_Init)
        love.graphics.setColor(1, 1, 1, 1)
    end

    for k, v in ipairs(listObus) do
        if v.nom == NomObus.Hero or v.nom == NomObus.Ennemis then
            love.graphics.draw(Img_Obus, v.x, v.y, v.angle, 1 / 2, 1 / 2, largeurImg_Obus / 2, hauteurImg_Obus / 2)
        elseif v.nom == NomObus.LaserTower then
            love.graphics.draw(
                Img_Laser,
                v.x - largeurImg_Tower / 3,
                v.y,
                v.angle,
                1 / 2,
                1 / 2,
                largeurImg_Tower / 2,
                largeurImg_Tower / 2
            )
        end
    end
end

return Weapons
