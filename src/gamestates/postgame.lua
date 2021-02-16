postgame = {
    results = {
        {player = 'A', color = 'red', score = '5 pts', place = '1st'},
        {player = 'B', color = 'green', score = '3 pts', place = '2nd'},
        {player = 'C', color = 'blue', score = '2 pts', place = '3rd'},
        {player = 'D', color = 'yellow', score = '1 pts', place = '4th'},
    },
    scoreHeight = 180,
}

function postgame.load()
    background.create()
    postgame.entries = {}
end

function postgame.start()
    for i, result in ipairs(postgame.results) do
        postgame.newEntry(result)
    end
    postgame.adjustScorePositions()
end

function postgame.draw()
    background.draw()

    for i, entry in ipairs(postgame.entries) do
        postgame.drawSingleEntry(entry)
    end 

    postgame.drawButtonPrompts()
end

function postgame.update(dt)
    background.update()

    for i, entry in ipairs(postgame.entries) do
        entry.y = entry.y + (entry.ty - entry.y) * 0.1
    end

    if controller.A ~= nil then
        if controller.A.isADown() then
            gamestates.setActive(game)
        elseif controller.A.isBDown() then
            gamestates.setActive(pregame)
        end
    end
end

function postgame.newEntry(result)
    local entry = {
        player = result.player,
        score = result.score,
        place = result.place,
        x = (config.video.width - sprites.ui_score:getWidth()) / 2,
        ty = config.video.height / 2 + postgame.scoreHeight * (#postgame.entries),
        y = 3000 + 5000 * #postgame.entries,
        sprite = animations.shipFromColor[result.color].frames[1],
        name = ships.nameFromColor[result.color], 
    }
    table.insert(postgame.entries, entry)
end

function postgame.drawSingleEntry(entry)
    love.graphics.push()
    love.graphics.translate(entry.x, entry.y)
    love.graphics.draw(sprites.ui_score)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fonts.result)
    fonts.outlineText(entry.place, 0, 30, 160, 'center')
    love.graphics.draw(entry.sprite, 180, 110, -math.pi / 2)

    love.graphics.setFont(fonts.score)
    fonts.outlineText(entry.name .. '\n' .. entry.score, 250, 0, 500, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
end

function postgame.adjustScorePositions()
    for i, entry in ipairs(postgame.entries) do
        entry.ty = entry.ty - (#postgame.entries / 2) * postgame.scoreHeight
    end
end

function postgame.drawButtonPrompts()
    love.graphics.push()
    love.graphics.translate(520, 0)
    love.graphics.circle('fill', 25, 45, 10)
    love.graphics.setColor(0.2, 0.2, 0.8)
    love.graphics.draw(sprites.ui_X, 0, 20)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 325, 45, 10)
    love.graphics.setColor(0.8, 0.8, 0.2)
    love.graphics.draw(sprites.ui_Y, 300, 20)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fonts.place)

    fonts.outlineText('Rematch', 50, 15, 800, 'left')
    fonts.outlineText('Main Menu', 350, 15, 800, 'left')
    love.graphics.pop()
end