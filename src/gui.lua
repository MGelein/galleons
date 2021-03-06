gui = {}
gui.places = {'1st', '2nd', '3rd', '4th'}

function gui.new()
    ui = {
        havePowerup = false,
        readyToShoot = true,
        heartParts = 0,
        hearts = {sprites.heart_empty, sprites.heart_empty, sprites.heart_empty},
        heartox = sprites.heart_empty:getWidth() / 2,
        rightIcon = sprites.ui_cannonball,
        rightScale = 1,
        rightScaleAcc = 0,
        rightAlpha = 1,
        leftIcon = nil,
        leftScale = 1,
        leftScaleAcc = 0,
        leftAlpha = 1,
        accentColor = {r = 1, g = 1, b = 1},
        scoreValue = 1,
    }
    return ui
end

function gui.useLeftIcon(ui)
    ui.leftScaleAcc = 0.05;
end

function gui.useRightIcon(ui)
    ui.rightScaleAcc = 0.05
    ui.readyToShoot = false
end

function gui.setHeartParts(ui, heartParts)
    ui.heartParts = heartParts
    ui.hearts = {
        gui.getHeartSprite(1, heartParts),
        gui.getHeartSprite(2, heartParts),
        gui.getHeartSprite(3, heartParts),
    }
end

function gui.draw(ui, w, h)
    gui.useFontColorWithAlpha(ui.leftAlpha)
    gui.drawIcon(sprites.ui_tile, 10, 10, ui.leftScale, 0)
    love.graphics.setColor(1, 1, 1, 1)
    gui.drawIcon(ui.leftIcon, 18, 15, ui.leftScale, 0)
    gui.useFontColorWithAlpha(ui.leftAlpha)
    gui.drawIcon(sprites.ui_tileL1, 10, 10, ui.leftScale, 0)
    
    gui.useFontColorWithAlpha(ui.rightAlpha)
    local offset = sprites.ui_tileR1:getWidth() * ui.rightScale
    gui.drawIcon(sprites.ui_tile, w - 10, 10, ui.rightScale, offset)
    love.graphics.setColor(1, 1, 1, 1)
    gui.drawIcon(ui.rightIcon, w - 10, 23, ui.rightScale * .8, offset)
    gui.useFontColorWithAlpha(ui.rightAlpha)
    gui.drawIcon(sprites.ui_tileR1, w - 10, 10, ui.rightScale, offset)

    love.graphics.setColor(1, 1, 1, 1)
    gui.drawIcon(ui.hearts[1], w / 2 - 40, 10, 1, ui.heartox)
    gui.drawIcon(ui.hearts[2], w / 2, 10, 1, ui.heartox)
    gui.drawIcon(ui.hearts[3], w / 2 + 40, 10, 1, ui.heartox)
    
    gui.useFontColor()
    love.graphics.setFont(fonts.place)
    gui.drawOutlinedString(ui, w - 10, h - 10)
    love.graphics.setColor(1, 1, 1, 1)
    
    minimap.draw(w, h)
end

function gui.drawOutlinedString(ui, x, y)
    local unit = ' pts'
    if game.mode == game.captureTheFlag then
        unit = ' flags'
        if ui.scoreValue == 1 then unit = ' flag' end
    end
    local string = ui.scoreValue .. unit -- default assumed is deathmatch
    if game.mode == game.kingOfTheHill then string = gui.getPlaceName(ui.scoreValue) end
    if game.mode == game.captureTheFlag then string = ui.scoreValue .. unit end

    local offset = minimap.size
    love.graphics.draw(sprites.ui_tile_wide, x - offset, y - offset / 2)
    fonts.outlineText(string, x - offset, y + 10 - offset / 2, minimap.size, 'center')
end

function gui.useFontColor()
    local c = config.ui.col
    love.graphics.setColor(c.r, c.g, c.b, c.a)
end

function gui.useFontColorWithAlpha(a)
    local c = config.ui.col
    love.graphics.setColor(c.r, c.g, c.b, a)
end

function gui.getPlaceName(place)
    if game.mode == game.kingOfTheHill then
        if place == 1 then return 'King'
        else return 'Serf' end
    end
    return gui.places[place]
end

function gui.getHeartSprite(numHeart, healthLevel)
    healthLevel = math.floor(healthLevel + 0.5)
    if healthLevel < (numHeart - 1) * 4 then 
        return sprites.heart_empty 
    elseif healthLevel >= numHeart * 4 then
        return sprites.heart_full
    end
    return animations.uiHeart.frames[healthLevel % 4 + 1]
end

function gui.update(ui)
    ui.leftScale = ui.leftScale + ui.leftScaleAcc;
    ui.leftScaleAcc = ui.leftScaleAcc * 0.95;
    ui.leftScale = (1 - ui.leftScale) * 0.2 + ui.leftScale;
    
    ui.rightScale = ui.rightScale + ui.rightScaleAcc
    ui.rightScaleAcc = ui.rightScaleAcc * 0.95
    ui.rightScale = (1 - ui.rightScale) * 0.2 + ui.rightScale
    
    ui.rightAlpha = 0.5
    if ui.readyToShoot and ui.rightIcon ~= nil then ui.rightAlpha = 1 end
    ui.leftAlpha = 0.5
    if ui.havePowerup and ui.leftIcon ~= nil then ui.leftAlpha = 1 end
end

function gui.drawIcon(icon, x, y, s, offset)
    if icon == nil then return end
    love.graphics.draw(icon, x, y, 0, s, s, offset)
end

function gui.setLeftIcon(ui, image)
    ui.leftIcon = image
    if image == nil then ui.havePowerup = false 
    else ui.havePowerup = true end
end