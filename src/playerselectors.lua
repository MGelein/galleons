playerselectors = {
    halfheight = sprites.ui_playerselector_bg:getHeight() / 2,
    spriteox = sprites.white_full:getWidth() / 2,
    spriteoy = sprites.white_full:getHeight() / 2,
    iconox = sprites.ui_A:getWidth() / 2,
    iconoy = sprites.ui_A:getHeight() / 2,
    arrowox = sprites.ui_arrow:getWidth() / 2,
    arrowoy = sprites.ui_arrow:getHeight() / 2,
    forward = 1,
    backward = -1,
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

function playerselectors.show()
    for i, selector in ipairs(playerselectors.list) do
        selector.ty = 50
    end
end

function playerselectors.new(character, posX, posY)
    local selector = {
        letter = character,
        x = posX,
        y = 5000 + posX * 10,
        tx = posX,
        ty = 5000 + posX * 10,
        waiting = true,
        color = {},
        colorName = '',
        colorIndex = 0,
        moveTimeout = 30,
        ready = false,
        timeout = 60, -- used to prevent you from immediately clicking A as you use it to join
    }
    table.insert(playerselectors.list, selector)
end

function playerselectors.update(pregameState)
    for i, selector in ipairs(playerselectors.list) do
        selector.y = (selector.ty - selector.y) * 0.1 + selector.y
        if pregameState > 0 then
            if controller[selector.letter] then
                if selector.waiting then
                    selector.colorIndex = playerselectors.nextAvailableColorIndex(1, playerselectors.forward)
                    selector.waiting = false
                end
                selector.colorName = playerselectors.indexToColor[selector.colorIndex]
                selector.color = sprites.colorFromName[selector.colorName]
                selector.sprite = animations.shipFromColor[selector.colorName].frames[1]
                selector.moveTimeout = decrease(selector.moveTimeout)
                selector.timeout = decrease(selector.timeout)
                
                local controller = controller[selector.letter]
                if selector.moveTimeout <= 0 and not selector.ready then
                    local value = controller.getLeftX()
                    local move = 0
                    if value > 0.5 then
                        move = playerselectors.forward
                    elseif value < -0.5 then
                        move = playerselectors.backward
                    end
                    if move ~= 0 then
                        selector.colorIndex = playerselectors.nextAvailableColorIndex(selector.colorIndex, move)
                        selector.moveTimeout = config.ui.moveTimeout
                    end
                end
    
                if not selector.ready and controller.isADown() and selector.timeout <= 0 then selector.ready = true
                elseif selector.ready and controller.isBDown() and selector.timeout <= 0 then selector.ready = false
                end
                
            else
                selector.waiting = true
            end
        end
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
        fonts.outlineText("Press any button to join", 10, playerselectors.halfheight - 32, 280, 'center')
    else
        fonts.outlineText('Player ' .. selector.letter, 10, 32, 280, 'center')

        love.graphics.draw(selector.sprite, 155, 200, 0, 1, 1, playerselectors.spriteox, playerselectors.spriteoy)
        fonts.outlineText(ships.nameFromColor[selector.colorName], 10, 300, 280, 'center')
        
        fonts.outlineText('Press', 10, 400, 280, 'center')
        local icon = sprites.ui_A
        local msg = 'when ready'
        local col = {r = 0.2, g = 0.8, b = 0.2, a = 1}
        if selector.ready then
            icon = sprites.ui_B
            msg = 'to cancel'
            col = {r = 0.8, g = 0.2, b = 0.2, a = 1} 
        end
        love.graphics.setColor(col.r, col.g, col.b, col.a)
        love.graphics.draw(icon, 145, 480, 0, 1, 1, playerselectors.iconox, playerselectors.iconoy)
        love.graphics.setColor(1, 1, 1, 1)
        fonts.outlineText(msg, 10, 500, 280, 'center')
        
        if not selector.ready then
            love.graphics.setColor(selector.color.r, selector.color.g, selector.color.b, 1)
            love.graphics.draw(sprites.ui_arrow, 250, 200, 0, 1, 1, playerselectors.arrowox, playerselectors.arrowoy)
            love.graphics.draw(sprites.ui_arrow, 50, 200, math.pi, 1, 1, playerselectors.arrowox, playerselectors.arrowoy)
        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(sprites.ui_tile_wide, 70, -80)
            fonts.outlineText('Ready!', 10, -65, 280, 'center')
        end
        
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function playerselectors.isEveryoneReady()
    local numReady = 0
    for i, selector in ipairs(playerselectors.list) do
        if not selector.waiting and not selector.ready then return false end
        if selector.ready then
            numReady = numReady + 1
        end
    end
    if numReady > 0 then return true    
    else return false end
end

function playerselectors.getPlayers()
    local players = {}
    for i, selector in ipairs(playerselectors.list) do
        if selector.ready then
            players[selector.letter] = selector.colorName
        end
    end
    return players
end

function playerselectors.nextAvailableColorIndex(colorIndex, dir)
    local nextColorIndex = colorIndex
    while playerselectors.isColorIndexTaken(nextColorIndex) do
        nextColorIndex = nextColorIndex + dir
        if nextColorIndex > #playerselectors.indexToColor then 
            nextColorIndex = 1
        elseif nextColorIndex <= 1 then 
            nextColorIndex = #playerselectors.indexToColor 
        end
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