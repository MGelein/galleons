collisions = {}

function collisions.handleShip(ship)
    for shape, delta in pairs(hc.collisions(ship.collider)) do
        if shape.class == 'ship' then
            ships.ram(ship, shape.parent, delta)
        elseif shape.class == 'spawn' then
            collisions.resolve(ship, delta, 1, 0.2)
        elseif shape.class == 'border' then
            collisions.resolve(ship, delta, 0.03, 0.9)
        elseif shape.class == 'powerup' then
            powerups.remove(shape.parent)
            sounds.woodBreak()
            sounds.splash()
            if ship.powerup == 'none' then ship.powerup = powerups.get(ship) end
        elseif shape.class == 'mine' then
            mines.detonate(shape.parent)
            ships.damage(ship, config.powerups.mineDamage / 4)
        elseif shape.class == 'shockwave' then
            ships.damage(ship, config.powerups.mineDamage / 4)
        end
    end
end

function collisions.handleShockwave(shockwave)
    for shape, dleta in pairs(hc.collisions(shockwave.collider)) do
        if shape.class == 'mine' then mines.detonate(shape.parent) end
    end
end

function collisions.handleBullet(bullet)
    for shape, delta in pairs(hc.collisions(bullet.collider)) do
        if shape.class == 'bullet' or shape.class == 'border' or shape.class == 'shockwave' then
            -- do nothing
        else
            bullets.remove(bullet)
            explosions.new(bullet.x, bullet.y)

            if shape.class == 'mine' then mines.detonate(shape.parent) end
            
            if shape.class == 'ship' or shape.class == 'powerup' then
                sounds.impact()
            else
                sounds.impactSand()
            end

            if shape.class == 'ship' then
                ships.damage(shape.parent, 1)
            elseif shape.class == 'powerup' then
                powerups.remove(shape.parent)
            end
        end
    end
end

function collisions.handlePowerup(powerup)
    for shape, delta in pairs(hc.collisions(powerup.collider)) do
        if shape.class == 'spawn' then
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