ships = {}
ships.list = {}
ships.cannonPositions = {
    first = {r = 0.8, d = 42},
    second = {r = 1.4, d = 43},
    third = {r = 1.8, d = 42},
    fourth = {r = 2.2, d = 47},
}
ships.nameFromColor = {
    red = "Crimson Wave",
    green = "Lucky Clover",
    blue = "Stormhunter",
    yellow = "Golden Dubloon",
    white = "White Whale",
    black = "Night's Edge"
}
math.pi2 = math.pi / 2
math.twopi = math.pi * 2

function ships.draw()
    for i, ship in ipairs(ships.list) do
        if not ship.invulnerable and ship.alpha > 0.95 then
            love.graphics.draw(sprites.cannonRow, ship.x, ship.y, ship.r -ship.cor, ship.sx, ship.sy, ship.cox, ship.coy)
            if ship.machinegunFrames > 1 then
                love.graphics.draw(sprites.cannonRow, ship.x, ship.y, ship.r +ship.cor, ship.sx, ship.sy, ship.cox, ship.coy)
            end
        end

        love.graphics.setColor(ship.red, 1, 1, ship.alpha)
        love.graphics.draw(ship.sprite, ship.x, ship.y, ship.r - math.pi2, ship.sx, ship.sy, ship.ox, ship.oy)
        if config.showColliders then ship.collider:draw("line") end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function ships.damage(ship, damage)
    if not game.running then return end
    if damage > 0 then 
        screens.shake(ship.canvas, 30)
        sounds.woodBreak()
    end
    ship.health = ship.health - damage
    if ship.health > 12 then ship.health = 12
    elseif ship.health < 0 then ship.health = 0 end
    
    ship.sprite = ship.animation.frames[4 - math.ceil(ship.health / 4)]
    if ship.canvas ~= nil then gui.setHeartParts(ship.canvas.ui, ship.health) end
end

function ships.update()
    for i, ship in ipairs(ships.list) do
        if ship.reload == 0 then ship.canvas.ui.readyToShoot = true end
        if ship.machinegunFrames > 0 then ship.cannonPos = 1 end

        ship.reload = decrease(ship.reload)
        ship.machinegunFrames = decrease(ship.machinegunFrames)
        ship.mineCooldown = decrease(ship.mineCooldown)
        ship.invulnerableFrames = decrease(ship.invulnerableFrames)

        collisions.handleShip(ship)
        
        if ship.invulnerableFrames == 0 then 
            ship.invulnerable = false
        else
            ship.invulnerable = true
        end

        if ship.invulnerable then
            ship.alpha = (0.3 - ship.alpha) * 0.1 + ship.alpha
            ship.red = (0.3 - ship.red) * 0.1 + ship.alpha
        elseif ship.health > 0 then
            ship.alpha = (1 - ship.alpha) * 0.1 + ship.alpha
            ship.red = (1 - ship.red) * 0.1 + ship.red
        elseif ship.health <= 0 then
            ship.alpha = ship.alpha * 0.95
            if ship.alpha < 0.1 then
                ships.respawn(ship)
            end
        end

        ship.x = ship.x + ship.vx
        ship.y = ship.y + ship.vy
        ship.r = ship.r + ship.vr
        ship.r = ship.r % math.twopi
        ship.collider:moveTo(ship.x, ship.y)
        ship.collider:rotate(ship.r + math.pi2 - ship.colliderR)
        ship.colliderR = ship.r + math.pi2

        ship.cox = ship.ox - math.abs(ship.cannonPos) * 20
        ship.coy = ship.oy
        ship.cor = toDir(ship.cannonPos)
        ship.cannonPos = (ship.cannonPos + (ship.tCannonPos - ship.cannonPos) * .1) * ship.alpha

        ship.ax = ship.ax * 0.5
        ship.sx = (1 - ship.sx) * 0.2 + ship.sx
        ship.sx = ship.ax + ship.sx

        ship.vx = ship.vx * 0.95
        ship.vy = ship.vy * 0.95
        ship.vr = ship.vr * 0.8
        ship.speed = math.sqrt(ship.vx * ship.vx + ship.vy * ship.vy)
        ship.vx = (ship.vx + ship.speed * math.cos(ship.r)) / 2
        ship.vy = (ship.vy + ship.speed * math.sin(ship.r)) / 2
        ship.turboForce = ship.turboForce * 0.99
        ship.sy = 1 + (ship.turboForce / 3)

        if ship.health > 0 then
            if controller.exists(ship.letter) and game.running then
                ships.humanControl(ship, controller[ship.letter])
                ships.humanAim(ship, controller[ship.letter])
                ships.humanShoot(ship, controller[ship.letter])
                ships.humanPowerup(ship, controller[ship.letter])
            else
                ships.aiControl(ship)
            end
        end
        
    end
end

function ships.ram(ship1, ship2, delta)
    ship1.x = ship1.x + delta.x / 2
    ship1.y = ship1.y + delta.y / 2
    ship2.x = ship2.x - delta.x / 2
    ship2.y = ship2.y - delta.y / 2

    local deltaR = math.atan2(delta.y, delta.x) + math.pi
    local ship1Align = math.cos(deltaR - math.atan2(ship1.vy, ship1.vx))
    local ship2Align = math.cos(deltaR - math.atan2(ship2.vy, ship2.vx))
    local totalSpeed = ship1.speed + ship2.speed
    
    if totalSpeed > 5 then
        if math.abs(ship2Align) > math.abs(ship1Align) then 
            ships.damageByAndScore(ship1, ship2, 2)
        else
            ships.damageByAndScore(ship2, ship1, 2)
        end
    end

    local nvx = (ship1.vx + ship2.vx) / 2
    local nvy = (ship1.vy + ship2.vy) / 2
    ship2.vx = nvx
    ship2.vy = nvy
    ship1.vx = nvx
    ship1.vy = nvy
end

function ships.aiControl(ship)
    -- for now, do nothing, maybe at some point implement fancy ai stuff
end

function ships.humanPowerup(ship, controller)
    local leftTrigger = controller.getLeftTrigger()
    if (leftTrigger > 0.9 and ship.powerup ~= 'none') then
        if ship.powerup == 'mine' and ship.mineCooldown < 1 then
            powerups.apply(ship);
            ship.mineCooldown = config.powerups.mineReload

            if ship.mines < 1 then
                gui.setLeftIcon(ship.canvas.ui, nil)
                ship.powerup = 'none'
            end
        elseif ship.powerup ~= 'mine' then
            powerups.apply(ship);
            ship.powerup = 'none'
            gui.setLeftIcon(ship.canvas.ui, nil)
        end
    end
end

function ships.humanControl(ship, controller)
    local controlX = controller.getLeftX()
    local controlY = controller.getLeftY()
    if math.abs(controlX) < config.deadzone then controlX = 0 end
    if math.abs(controlY) < config.deadzone then controlY = 0 end
    ship.alignment = 0
    if controlX ~= 0 or controlY ~= 0 then
        local controlR = math.atan2(controlY, controlX)
        local diffR = controlR - ship.r
        ship.alignment = math.cos(diffR)
        if ship.alignment < 0 then ship.alignment = 0 end
        if math.abs(diffR) > math.pi then
            controlR = controlR + math.twopi
        end
        ship.vr = (controlR - ship.r) * .02
    end
    local f = config.ships.accForce + ship.turboForce
    ship.vx = ship.vx + controlX * f * ship.alignment
    ship.vy = ship.vy + controlY * f * ship.alignment
end

function ships.humanAim(ship, controller)
    local aimX = controller.getRightX()
    local aimY = controller.getRightY()
    if math.abs(aimX) < config.deadzone then aimX = 0 end
    if math.abs(aimY) < config.deadzone then aimY = 0 end
    if aimX == aimY and aimX == 0 then
        ship.tCannonPos = 0
    else
        local aimR = math.atan2(aimY, aimX)
        local diffR = aimR - ship.r
        if math.abs(diffR) > math.pi then
            aimR = aimR + math.twopi
        end
        ship.tCannonPos = -1
        if aimR > ship.r then
            ship.tCannonPos = 1
        end
    end
    if ship.machinegunFrames > 1 then
        ship.tCannonPos = 1
    end
end

function ships.humanShoot(ship, controller)
    local rightTrigger = controller.getRightTrigger()
    if rightTrigger > 0.9 and ship.reload < 1 and math.abs(ship.cannonPos) > 0.9 then
        gui.useRightIcon(ship.canvas.ui)
        ship.ax = 0.2
        ship.reload = 60
        if ship.machinegunFrames > 1 then ship.reload = config.powerups.machinegunReload end
        sounds.shoot()
        
        for name, pos in pairs(ships.cannonPositions) do
            local spread = (math.random() * 2 - 1) * config.bullets.spreadAngle
            local powerFactor = math.random() * config.bullets.spreadPower + (1 - config.bullets.spreadPower)
            local dirs = toDirs(ship.cannonPos, ship.machinegunFrames)
            for i, dir in ipairs(dirs) do
                local angle = dir * pos.r + ship.r
                local posX = math.cos(angle) * pos.d + ship.x
                local posY = math.sin(angle) * pos.d + ship.y
                local velX = math.cos(ship.r + math.pi2 * dir + spread) * (config.bullets.speed * powerFactor)
                local velY = math.sin(ship.r + math.pi2 * dir + spread) * (config.bullets.speed * powerFactor)
                bullets.new(ship, posX, posY, velX + ship.vx, velY + ship.vy, config.bullets.maxAge * powerFactor)
                ship.vx = ship.vx - velX * 0.1
                ship.vy = ship.vy - velY * 0.1
            end
        end
    end
end

function ships.new(player, colorName)
    local image = animations.shipFromColor[colorName]
    local ship = {
        letter = player,
        health = 12,
        reload = 0,
        cannonPos = 0,
        tCannonPos = 0,
        spawn = {},
        powerup = 'none',
        vx = 0,
        vy = 0,
        vr = 0,
        sy = 1,
        sx = 1,
        ax = 0, 
        speed = 0,
        mines = 0,
        mineCooldown = 0,

        colliderR = 0,
        turboForce = 0,
        animation = image,
        sprite = image.frames[1],
        alpha = 1,
        red = 1,
        color = sprites.colorFromName[colorName],
        
        cox = 0,
        coy = 0,
        cor = 0,
        machinegunFrames = 0,

        score = 0,
        damageDealt = 0,
        invulnerable = false,
        invulnerableFrames = 0,
    }
    ship.oy = ship.sprite:getHeight() / 2
    ship.ox = ship.sprite:getWidth() / 2
    ship.collider = hc.polygon(0,-45,  15,-25,  20,5,  35,10  ,30,40,  0,65,  -30,40,  -35,10,  -20,5,  -15,-25)
    ship.collider.parent = ship
    ship.collider.class = 'ship'
    
    local spawn = spawns.get(ship.letter)
    spawn.color = ship.color
    ships.setSpawn(ship, spawn.x, spawn.y, spawn.r - math.pi2)
    ships.damage(ship, 0)
    table.insert(ships.list, ship)
    return ship
end

function ships.setPlace(ship, place)
    ship.canvas.ui.scoreValue = place
end

function ships.setUIScore(ship)
    ship.canvas.ui.scoreValue = ship.score
end

function ships.damageByAndScore(damageShip, damagingShip, damage)
    if damageShip.health <= 0 then return end
    ships.damage(damageShip, damage)
    damagingShip.damageDealth = damagingShip.damageDealt + damage
    if damageShip.health <= 0 and game.scoringMode == 'points' and damageShip ~= damagingShip then
        damagingShip.score = damagingShip.score + 1
    end
end

function ships.setSpawn(ship, x, y, r)
    ship.spawn.x = x * 0.95
    ship.spawn.y = y * 0.95
    ship.spawn.r = r
    ship.x = ship.spawn.x
    ship.y = ship.spawn.y
    ship.r = ship.spawn.r
end

function ships.get(letter)
    for i, ship in ipairs(ships.list) do
        if ship.letter == letter then
            return ship
        end
    end
    return nil
end

function ships.respawn(ship)
    ship.x = ship.spawn.x
    ship.y = ship.spawn.y
    ship.r = ship.spawn.r
    ship.vx = 0
    ship.vy = 0
    ship.cannonPos = 0
    ship.alpha = 1
    ship.powerup = 'none'
    ship.turboForce = 0
    ship.machinegunFrames = 0
    ship.mines = 0
    ship.reload = 0
    ship.mineCooldown = 0
    gui.setLeftIcon(ship.canvas.ui, nil)
    ships.damage(ship, -12)
end

function ships.create(defs)
    for letter, color in pairs(defs) do
        ships.new(letter, color)
    end
end