smoke = {}
smoke.list = {}
smoke.toRemove = {}

function smoke.new(posX, posY)
    local newSmoke = {
        x = posX,
        y = posY,
        r = math.random() * math.twopi,
        s = math.random() * .5 + .5,
        frame = 1,
        frameCounter = 0,
    }
    table.insert(smoke.list, newSmoke)
end

function smoke.draw()
    for i, smokeObj in ipairs(smoke.list) do
        local image = animations.smoke.frames[smokeObj.frame]
        local ox = image:getWidth() / 2
        local oy = image:getHeight() / 2
        love.graphics.draw(image, smokeObj.x, smokeObj.y, smokeObj.r, smokeObj.s, smokeObj.s, ox, oy)
    end
end

function smoke.update()
    for i, smokeObj in ipairs(smoke.list) do
        smokeObj.frameCounter = smokeObj.frameCounter + 1
        if smokeObj.frameCounter >= animations.smoke.speed then
            smokeObj.frameCounter = 0
            smokeObj.frame = smokeObj.frame + 1
            if smokeObj.frame > #animations.smoke.frames then
                smoke.remove(smokeObj)
            end
        end
    end

    if #smoke.toRemove > 0 then
        for i, toRem in ipairs(smoke.toRemove) do
            local foundIndex = -1
            for j, sObj in ipairs(smoke.list) do
                if sObj == toRem then 
                    foundIndex = j
                    break
                end
            end
            if foundIndex ~= -1 then table.remove(smoke.list, foundIndex) end
        end
        smoke.toRemove = {}
    end
end

function smoke.remove(smokeObj)
    table.insert(smoke.toRemove, smokeObj)
end

function smoke.removeAll()
    smoke.list = {}
    smoke.toRemove = {}
end