tornadoes = {
    ox = sprites.tornado:getWidth() / 2,
    oy = sprites.tornado:getHeight() / 2
}
tornadoes.list = {}
tornadoes.toRemove = {}

function tornadoes.new(parent, newX, newY)
    local tornado = {
        ship = parent,
        x = newX,
        y = newY,
        r = love.math.random() * math.pi * 2,
        vx = 0,
        vy = 0,
        ax = 0,
        ay = 0,
        dmg = 0,
        vr = 0.03,
        scale = 0,
        alpha = 0,
        age = 0,
        maxAge = config.powerups.tornadoAge,
        steeringForce = config.powerups.tornadoSteeringForce,
        collider = hc.circle(newX, newY, tornadoes.ox)
    }
    tornado.collider.parent = tornado
    tornado.collider.class = 'tornado'
    tornado.collider.currentScale = 1
    table.insert(tornadoes.list, tornado)
end

function tornadoes.update()
    for i, tornado in ipairs(tornadoes.list) do
        if tornado.age % 10 == 0 then 
            local splashScale = tornado.scale * 10 * (1 + love.math.random())
            splash.newSilent(tornado.x, tornado.y, tornado.scale * 20 * love.math.random()) 
        end

        tornado.x = tornado.x + tornado.vx
        tornado.y = tornado.y + tornado.vy
        tornado.r = tornado.r + tornado.vr
        tornado.vx = (tornado.vx + tornado.ax) * 0.95
        tornado.vy = (tornado.vy + tornado.ay) * 0.95
        tornado.age = tornado.age + 1
        tornadoes.moveAndScaleCollider(tornado)

        if tornado.age < 60 then
            tornado.scale = tornado.age / 60
            if tornado.age == 59 then tornado.dmg = config.powerups.tornadoDamage end
        elseif tornado.age >= tornado.maxAge then
            tornadoes.remove(tornado)
        elseif tornado.age > tornado.maxAge - 60 then
            if tornado.age == tornado.maxAge - 59 then tornado.dmg = 0 end
            tornado.scale = 1.00001 - (tornado.age - (tornado.maxAge - 60)) / 60
        else
            tornado.scale = 1
        end

        local distSq = 1000000000
        local closestShip = ships.list[1]
        local dx = 0
        local dy = 0
        for i, ship in ipairs(ships.list) do
            if ship ~= tornado.ship then
                dx = ship.x - tornado.x
                dy = ship.y - tornado.y
                if dx * dx + dy * dy < distSq then 
                    distSq = dx * dx + dy * dy
                    closestShip = ship
                end
            end
        end
        dx = closestShip.x + (closestShip.vx * 30) - tornado.x
        dy = closestShip.y + (closestShip.vy * 30) - tornado.y
        dist = math.sqrt(distSq)
        if dist < 1 then dist = 1 end
        tornado.ax = (dx / dist) * tornado.steeringForce
        tornado.ay = (dy / dist) * tornado.steeringForce
    end

    if #tornadoes.toRemove > 0 then
        for i, tornadoToRemove in ipairs(tornadoes.toRemove) do
            local foundIndex = -1
            for j, tornado in ipairs(tornadoes.list) do
                if tornado == tornadoToRemove then
                    foundIndex = j
                    break
                end
            end
            if foundIndex > 0 then table.remove(tornadoes.list, foundIndex) end
        end
        tornadoes.toRemove = {}
    end
end

function tornadoes.draw()
    for i, tornado in ipairs(tornadoes.list) do
        local scale = tornado.scale
        local ox = tornadoes.ox
        local oy = tornadoes.oy
        love.graphics.setColor(1, 1, 1, scale)
        love.graphics.draw(sprites.tornado, tornado.x, tornado.y, tornado.r, scale, scale, ox, oy)
        if config.showColliders then tornado.collider:draw('line') end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function tornadoes.remove(tornado)
    hc.remove(tornado.collider)
    table.insert(tornadoes.toRemove, tornado)
end

function tornadoes.moveAndScaleCollider(tornado)
    if tornado.scale > 0 then
        tornado.collider:scale(1 / tornado.collider.currentScale)
        tornado.collider:scale(tornado.scale)
        tornado.collider.currentScale = tornado.scale
    end
    tornado.collider:moveTo(tornado.x, tornado.y)
end