powerups = {
    ox = sprites.crate:getWidth() / 2, 
    oy = sprites.crate:getHeight() / 2,
}
powerups.list = {}
powerups.toRemove = {}
powerups.definitions = {
    turbo = {sprite = sprites.pu_turbo, chance = 1},
    mine = {sprite = sprites.pu_mine, chance = 1},
    health = {sprite = sprites.pu_health, chance = 1},
    machinegun = {sprite = sprites.pu_machinegun, chance = 1},
    tornado = {sprite = sprites.pu_tornado, chance = 1},
    aztecCoin = {sprite = sprites.pu_aztecCoin, chance = 1},
    -- use flags as a powerup, so you can pick up no others
    -- maybe kraken going for the leader
    -- grapeshot, sort of shotgun close range
    -- tidal wave, going forward from you
    -- gold pickups to increase speed, more booty! arrrrr!
}
powerups.rollTable = {}

for name, definition in pairs(powerups.definitions) do
    local amount = definition.chance
    while amount > 0 do
        amount = amount - 1
        table.insert(powerups.rollTable, name)
    end
end

function powerups.new()
    local dist = (0.2 + love.math.random()) * bounds.halfSize * 0.5
    local rot = love.math.random() * math.pi * 2
    local powerup = {
        x = math.cos(rot) * dist,
        y = math.sin(rot) * dist,
        r = 0,
        vr = 0,
        ar = 0.001,
        s = 1,
        scaleAngle = love.math.random() * math.pi2,
        age = love.math.random() * 60,
        collider = hc.circle(0, 0, powerups.ox * 1.2),
        baseScale = 0,
    }
    powerup.collider:moveTo(powerup.x, powerup.y)
    powerup.collider.class = 'powerup'
    powerup.collider.parent = powerup
    table.insert(powerups.list, powerup)
end

function powerups.draw()
    for i, powerup in ipairs(powerups.list) do
        love.graphics.draw(sprites.crate, powerup.x, powerup.y, powerup.r, powerup.s, powerup.s, powerups.ox, powerups.oy)
        if config.showColliders then powerup.collider:draw('line') end
    end
end

function powerups.update()
    if #powerups.list < config.powerups.amt then powerups.new() end

    for i, powerup in ipairs(powerups.list) do
        powerup.r = powerup.r + powerup.vr
        powerup.vr = (powerup.vr + powerup.ar * love.math.random()) * 0.95

        powerup.scaleAngle = powerup.scaleAngle + 0.05
        powerup.s = math.sin(powerup.scaleAngle) * 0.07 + powerup.baseScale

        powerup.age = powerup.age + 1 + love.math.random() * 0.1
        local ageRatio = powerup.age / config.powerups.maxAge
        if ageRatio > 0.9 then
            powerup.baseScale = (1 - ageRatio) * 10
        elseif ageRatio < 0.1 then
            powerup.baseScale = (ageRatio) * 10
        end
        if powerup.age > config.powerups.maxAge then powerups.remove(powerup) end

        collisions.handlePowerup(powerup)
    end

    if #powerups.toRemove > 0 then
        for index, powerupsToRemove in ipairs(powerups.toRemove) do
            local foundIndex = -1
            for i, powerup in ipairs(powerups.list) do
                if powerup == powerupsToRemove then
                    foundIndex = i 
                    break
                end
            end
            if foundIndex > -1 then table.remove(powerups.list, foundIndex) end
        end
        powerups.toRemove = {}
    end
end

function powerups.remove(powerup)
    hc.remove(powerup.collider)
    table.insert(powerups.toRemove, powerup)
end

function powerups.get(ship)
    local index = math.ceil(love.math.random() * #powerups.rollTable)
    local powerup = powerups.rollTable[index]
    gui.setLeftIcon(ship.canvas.ui, powerups.definitions[powerup].sprite)
    if powerup == 'mine' then ship.mines = config.powerups.mineAmt end
    return powerup
end

function powerups.apply(ship)
    gui.useLeftIcon(ship.canvas.ui)
    if(ship.powerup == 'turbo') then
        sounds.stopAndPlay(sounds.gust)
        ship.turboForce = config.powerups.turboForce
    elseif(ship.powerup == 'health') then
        sounds.stopAndPlay(sounds.repair)
        ships.damage(ship, -config.powerups.healthIncrease)
    elseif(ship.powerup == 'machinegun') then
        sounds.stopAndPlay(sounds.cannonsReady)
        ship.machinegunFrames = config.powerups.machinegunTime
    elseif(ship.powerup == 'mine') then
        sounds.splash()
        ship.mines = ship.mines - 1
        local posX = math.cos(ship.r + math.pi) * 65 + ship.x
        local posY = math.sin(ship.r + math.pi) * 65 + ship.y
        mines.new(ship, posX, posY)
    elseif(ship.powerup == 'tornado') then
        tornadoes.new(ship, ship.x, ship.y)
    elseif(ship.powerup == 'aztecCoin') then
        sounds.stopAndPlay(sounds.ghost)
        ship.invulnerableFrames = config.powerups.aztecCoinDuration
    end
end