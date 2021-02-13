playerselectors = {
    halfheight = sprites.ui_playerselector_bg:getHeight() / 2
}
playerselectors.list = {}
playerselectors.indexToColor = {'red', 'green', 'blue', 'yellow', 'white', 'black'}

function playerselectors.create()
    local w = config.video.width
    local h = config.video.height
    local xbuffer = 200
    local selWidth = (w - xbuffer * 2) / 4
    playerselectors.new('A', xbuffer, 0)
    playerselectors.new('B', xbuffer + 1 * selWidth, 0)
    playerselectors.new('C', xbuffer + 2 * selWidth, 0)
    playerselectors.new('D', xbuffer + 3 * selWidth, 0)
end

function playerselectors.new(character, posX, posY)
    local selector = {
        letter = character,
        x = posX,
        y = posY + 100,
        waiting = true,
        color = {},
        colorName = '',
        colorIndex = 0,
    }
    table.insert(playerselectors.list, selector)
end

function playerselectors.update()
    for i, selector in ipairs(playerselectors.list) do
        if controller[selector.letter] then
            if selector.waiting then
                selector.colorIndex = playerselectors.nextAvailableColorIndex(1)
            end
            selector.waiting = false
        else
            selector.waiting = true
        end
        selector.colorName = playerselectors.indexToColor[selector.colorIndex]
        selector.color = sprites.colorFromName[selector.colorName]
    end
end

function playerselectors.draw()
    love.graphics.push()
    love.graphics.translate(0, 100)
    for i, selector in ipairs(playerselectors.list) do
        love.graphics.push()
        love.graphics.translate(selector.x, selector.y)
        playerselectors.drawSingle(selector)
        love.graphics.pop()
    end
    love.graphics.pop()
end

function playerselectors.drawSingle(selector)
    love.graphics.setFont(fonts.normal)
    love.graphics.draw(sprites.ui_playerselector_bg, 10, 0)
    if selector.waiting then
        love.graphics.printf("Press any button to join", 10, playerselectors.halfheight - 32, 280, 'center')
    else
        love.graphics.draw(sprites.ui_playerselector_bg, 10, 0)
        love.graphics.setColor(fonts.black.r, fonts.black.g, fonts.black.b, 1)
        love.graphics.printf('Player ' .. selector.letter, 10, 32, 280, 'center')
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function playerselectors.nextAvailableColorIndex(colorIndex)
    local nextColorIndex = colorIndex
    while playerselectors.isColorIndexTaken(nextColorIndex) do
        nextColorIndex = nextColorIndex + 1
        if nextColorIndex > #playerselectors.indexToColor then nextColorIndex = 1 end
    end
    return nextColorIndex
end

function playerselectors.isColorIndexTaken(colorIndex)
    if colorIndex <= 0 or colorIndex > #playerselectors.indexToColor then return true end
    for i, selector in ipairs(playerselectors.list) do
        if selector.colorIndex == colorIndex then return true end
    end
    return false
end