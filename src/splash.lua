splash = {}
splash.list = {}
splash.toRemove = {}

function splash.new(xPos, yPos, radius)
    splash.newSilent(xPos, yPos, radius)
    sounds.splash()
end

function splash.newSilent(xPos, yPos, radius)
    local s = {
        x = xPos,
        y = yPos,
        r = radius,
        vr = radius / 10,
        alpha = 1,
        frames = 0,
        maxFrames = math.random() * 10 + 60
    }
    table.insert(splash.list, s)
end

function splash.draw()
    love.graphics.setLineWidth(4)
    for i, s in ipairs(splash.list) do
        love.graphics.setColor(1, 1, 1, s.alpha * s.alpha)
        love.graphics.circle("line", s.x, s.y, s.r)
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
end

function splash.update()
    for i, s in ipairs(splash.list) do
        s.r = s.r + s.vr
        s.frames = s.frames + 1
        if s.frames > s.maxFrames then splash.remove(s) end
        s.alpha = 1 - (s.frames / s.maxFrames)
    end

    if #splash.toRemove > 0 then
        for index, splashToRemove in ipairs(splash.toRemove) do
            local foundIndex = -1
            for i, s in ipairs(splash.list) do
                if s == splashToRemove then
                    foundIndex = i 
                    break
                end
            end
            if foundIndex > -1 then table.remove(splash.list, foundIndex) end
        end
        splash.toRemove = {}
    end
end

function splash.remove(s)
    table.insert(splash.toRemove, s)
end