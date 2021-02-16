collisions = {}
collisions.point = hc.circle(0, 0, 5) -- this collider is used to probe for objects at locations

function collisions.handleShip(ship)
    for shape, delta in pairs(hc.collisions(ship.collider)) do
        if shape.class == 'land' then
            collisions.resolve(ship, delta, 1, 0.2)
        elseif shape.class == 'border' then
            collisions.resolve(ship, delta, 0.03, 0.9)
        end
        
        if not ship.invulnerable then
            if shape.class == 'ship' then
                if not shape.parent.invulnerable then 
                    ships.ram(ship, shape.parent, delta)
                end
            elseif shape.class == 'powerup' then
                powerups.remove(shape.parent)
                sounds.woodBreak()
                sounds.splash()
                if ship.powerup == 'none' then ship.powerup = powerups.get(ship) end
            elseif shape.class == 'mine' then
                mines.detonate(shape.parent)
                ships.damageByAndScore(ship, shape.parent.ship, config.powerups.mineDamage / 4)
            elseif shape.class == 'shockwave' then
                ships.damageByAndScore(ship, shape.parent.ship, config.powerups.mineDamage / 4)
            elseif shape.class == 'tornado' then
                local tornado = shape.parent
                ships.damageByAndScore(ship, tornado.ship, tornado.dmg)
            end
        end
    end
end

function collisions.handleShockwave(shockwave)
    for shape, dleta in pairs(hc.collisions(shockwave.collider)) do
        if shape.class == 'mine' then mines.detonate(shape.parent) end
    end
end

function collisions.isLand(xPos, yPos)
    collisions.point:moveTo(xPos, yPos)
    for shape, delta in pairs(hc.collisions(collisions.point)) do
        if shape.class == 'land' then return true end
    end
    collisions.point:moveTo(bounds.dim, bounds.dim)
    return false
end

function collisions.handleFlag(flag)
    for shape, delta in pairs(hc.collisions(flag.collider)) do
        if shape.class == 'ship' then
            local ship = shape.parent
            if ship.powerup == 'none' then
                flags.remove(flag)
                ships.setPowerup(ship, flag.color .. 'Flag')
            end
        end
    end
end

function collisions.handleBullet(bullet)
    for shape, delta in pairs(hc.collisions(bullet.collider)) do
        local class = shape.class
        if collisions.isTransparentForBullets(class) then
            -- do nothing
        else
            bullets.remove(bullet)
            explosions.new(bullet.x, bullet.y)

            if class == 'mine' then mines.detonate(shape.parent) end
            
            if class == 'ship' or class == 'powerup' then
                sounds.impact()
            else
                sounds.impactSand()
            end

            if class == 'ship' then
                if not shape.parent.invulnerable then
                    ships.damageByAndScore(shape.parent, bullet.ship, config.bullets.damage)
                end
            elseif class == 'powerup' then
                powerups.remove(shape.parent)
            end
        end
    end
end

function collisions.handlePowerup(powerup)
    for shape, delta in pairs(hc.collisions(powerup.collider)) do
        if shape.class == 'land' then
            powerups.remove(powerup)
        elseif shape.class == 'tornado' or shape.class == 'shockwave' then
            sounds.woodBreak()
            powerups.remove(powerup)
        end
    end
end

function collisions.resolve(object, delta, hardness, restitution)
    object.x = object.x + delta.x * hardness
    object.y = object.y + delta.y * hardness
    object.vx = object.vx * restitution
    object.vy = object.vy * restitution
end

function collisions.isTransparentForBullets(class)
    if class == 'bullet' or class == 'border' or class == 'shockwave' then return true
    elseif class == 'tornado' or class == 'center' or class =='land' then return true
    elseif class == 'flag' then return true
    end
    return false 
end