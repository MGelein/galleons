bullets = {
    ox = sprites.cannonBall:getWidth() / 2, 
    oy = sprites.cannonBall:getHeight() / 2
}
bullets.list = {}
bullets.toRemove = {}

function bullets.new(xPos, yPos, xVel, yVel, maxAge)
    local bullet = {
        x = xPos,
        y = yPos,
        s = 1,
        collider = hc.circle(xPos, yPos, bullets.ox),
        vx = xVel,
        vy = yVel,
        frames = 0,
        maxFrames = maxAge,
    }
    bullet.collider.parent = bullet
    bullet.collider.class = 'bullet'
    table.insert(bullets.list, bullet)
    return bullet
end

function bullets.draw()
    for i, bullet in ipairs(bullets.list) do
        love.graphics.draw(sprites.cannonBall, bullet.x, bullet.y, 0, bullet.s, bullet.s, bullets.ox, bullets.oy)
        if config.showColliders then bullet.collider:draw() end
    end
end

function bullets.update()
    for i, bullet in ipairs(bullets.list) do
        bullet.x = bullet.x + bullet.vx
        bullet.y = bullet.y + bullet.vy
        bullet.vx = bullet.vx * 0.99
        bullet.vy = bullet.vy * 0.99
        bullet.frames = bullet.frames + 1
        bullet.collider:moveTo(bullet.x, bullet.y)
        local lifeAngle = (bullet.frames / bullet.maxFrames) * math.pi
        bullet.s = 1 + math.sin(lifeAngle) * .2

        if bullet.frames > bullet.maxFrames then
            bullets.remove(bullet)
            splash.new(bullet.x, bullet.y, bullets.ox)
        end
        collisions.handleBullet(bullet)
    end

    if #bullets.toRemove > 0 then
        for i, removeBullet in ipairs(bullets.toRemove) do
            local index = -1
            for checkIndex, bullet in ipairs(bullets.list) do
                if bullet == removeBullet then
                    index = checkIndex
                    break
                end
            end
            if index > -1 then table.remove(bullets.list, index) end
        end
        bullets.toRemove = {}
    end
end

function bullets.remove(bullet)
    hc.remove(bullet.collider)
    table.insert(bullets.toRemove, bullet)
end