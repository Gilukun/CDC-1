function CreerEnnemy(pNom, pX, pY, pVitesse, pAngle, pLife, pEtat, pDist, )
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