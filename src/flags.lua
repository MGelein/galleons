flags = {
    oy = sprites.flagRed:getHeight() / 2,
    itemOX = sprites.redFlag:getWidth() / 2,
    itemOY = sprites.redFlag:getHeight() / 2,
}

flags.colorToSprite = {
    red = sprites.flagRed,
    green = sprites.flagGreen,
    blue = sprites.flagBlue,
    yellow = sprites.flagYellow,
    white = sprites.flagWhite,
    black = sprites.flagBlack,
}

flags.colorToPowerup = {
    red = sprites.redFlag,
    blue = sprites.blueFlag,
    green = sprites.greenFlag,
    yellow = sprites.yellowFlag,
    white = sprites.whiteFlag,
    black = sprites.blackFlag
}

flags.list = {}
flags.toRemove = {}
flags.targetScale = 0.6

function flags.new(posX, posY, flagColor)
    local flag = {
        x = posX,
        y = posY,
        s = 0.6,
        sAngle = love.math.random() * math.pi,
        color = flagColor,
        sprite = flags.colorToPowerup[flagColor],
        collider = hc.polygon(posX-15,posY-20,  posX+15,posY-15,  posX-10,posY+20)
    }
    flag.collider.class = 'flag'
    flag.collider.parent = flag
    table.insert(flags.list, flag)
end

function flags.draw()
    for i, flag in ipairs(flags.list) do
        love.graphics.draw(flag.sprite, flag.x, flag.y, 0, flag.s, flag.s, flags.itemOX, flags.itemOY)
        if config.showColliders then flag.collider:draw('line') end
    end
end

function flags.update()
    for i, flag in ipairs(flags.list) do
        flag.sAngle = flag.sAngle + love.math.random() * 0.1
        flag.s = math.sin(flag.sAngle) * 0.05 + flags.targetScale

        collisions.handleFlag(flag)
    end

    if #flags.toRemove > 0 then
        for i, toRem in ipairs(flags.toRemove) do
            local foundIndex = -1
            for j, flag in ipairs(flags.list) do
                if flag == toRem then
                    foundIndex = j
                    break
                end
            end
            if foundIndex ~= -1 then table.remove(flags.list, foundIndex) end
        end
        flags.toRemove = {}
    end
end

function flags.remove(flag)
    table.insert(flags.toRemove, flag)
end

function flags.removeAll()
    for i, flag in ipairs(flags.list) do
        hc.remove(flag.collider)
    end
    for i, flag in ipairs(flags.toRemove) do
        if flag.collider ~= nil then hc.remove(flag.collider) end
    end
    flags.list = {}
    flags.toRemove = {}
end