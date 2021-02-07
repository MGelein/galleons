screens = {}
screens.list = {}

function screens.create()
    local amount = #ships.list
    local w2 = config.window.width / 2
    local h2 = config.window.height / 2
    if amount == 1 then 
        screens.new(0, 0, config.window.width, config.window.height)
    elseif amount == 2 then
        screens.new(0, 0, w2, config.window.height)
        screens.new(w2, 0, w2, config.window.height)
    elseif amount > 2 then
        screens.new(0, 0, w2, h2)
        screens.new(w2, 0, w2, h2)
        screens.new(0, h2, w2, h2)
        screens.new(w2, h2, w2, h2)
    end
    countdown.calculatePosition()
end

function screens.new(xPos, yPos, width, height)
    local letters = {'A', 'B', 'C', 'D'}
    local character = letters[#screens.list + 1]
    local screen = {
        letter = character,
        canvas = love.graphics.newCanvas(width, height),
        x = xPos,
        y = yPos,
        w = width,
        w2 = width / 2,
        h = height,
        h2 = height / 2,
        ox = 0,
        oy = 0,
        ui = gui.new(),
        shake = {x = 0, y = 0, vx = 0, vy = 0, frames = 0},
        follow = ships.get(character),
    }
    screen.follow.canvas = screen
    screen.ui.accentColor = screen.follow.color
    gui.setHeartParts(screen.ui, screen.follow.health)
    table.insert(screens.list, screen)
    return screen
end

function screens.shake(screen, frames)
    if screen.shake.frames < frames then screen.shake.frames = frames end
end

function screens.followEntity(screen, entity)
    screen.ox = screen.ox + (screen.w2 - entity.x - screen.ox) * .05
    screen.oy = screen.oy + (screen.h2 - entity.y - screen.oy) * .05
end

function screens.update()
    for i, screen in ipairs(screens.list) do
        gui.update(screen.ui)
        local sh = screen.shake
        sh.x = (sh.x + sh.vx) * 0.9
        sh.y = (sh.y + sh.vy) * 0.9
        if sh.frames > 0 then
            sh.frames = sh.frames - 1
            sh.force = 8
            if sh.force > sh.frames then sh.force = sh.frames end
            sh.vx = sh.vx + math.random() * sh.force - sh.force / 2
            sh.vy = sh.vy + math.random() * sh.force - sh.force / 2
        end
        sh.vy = sh.vy * 0.6
        sh.vx = sh.vx * 0.6
        sh.vx = sh.vx -sh.x * 0.2
        sh.vy = sh.vy -sh.y * 0.2

        if screen.follow ~= nil then screens.followEntity(screen, screen.follow) end
    end
    countdown.update()
end

function screens.draw(drawFn)
    local drawFunction = drawFn
    for i, screen in ipairs(screens.list) do
        love.graphics.setCanvas(screen.canvas)
        love.graphics.push()
        love.graphics.translate(screen.ox + screen.shake.x, screen.oy + screen.shake.y)
        drawFunction(screen)
        love.graphics.pop()
        gui.draw(screen.ui, screen.w, screen.h)
        love.graphics.setCanvas()
        love.graphics.draw(screen.canvas, screen.x, screen.y)
    end
    countdown.draw()
end

function screens.get(letter)
    for i, screen in ipairs(screens.list) do
        if screen.letter == letter then return screen end
    end
end