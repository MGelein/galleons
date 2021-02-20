settings = {
    moveTimeout = 0,
    marginTop = 150,
    spacing = 80,
    selectedRow = 1,
    resolutions = {
        {width = 1280, height = 720},
        {width = 1366, height = 768},
        {width = 1536, height = 864},
        {width = 1600, height = 900},
        {width = 1900, height = 1080},
        {width = 2048, height = 1152},
        {width = 2560, height = 1440},
    },
    resolutionIndex = 1,
    fullscreen = config.window.fullscreen,
}

function settings.load()
    background.create()
    settings.resolutionIndex = settings.getResolutionIndex()
end

function settings.start()
    sounds.playAmbience()
end

function settings.draw()
    background.draw()
    settings.drawButtonPrompts()

    love.graphics.push()
    love.graphics.translate(0, settings.marginTop)
    settings.drawResolution()
    settings.drawFullscreen()
    -- fx volume
    -- ambience volume
    -- music volume
    love.graphics.pop()
end

function settings.update(dt)
    background.update()
    settings.moveTimeout = decrease(settings.moveTimeout)

    if controller.A ~= nil then
        settings.parseControlInput(controller.A)
    end
end

function settings.apply()
    config.window.fullscreen = settings.fullscreen
    local res = settings.resolutions[settings.resolutionIndex]
    screens.setResolution(res.width, res.height)
end

function settings.parseControlInput(controller)
    if controller.isYDown() then gamestates.setActive(mainmenu) end
    if controller.isADown() then settings.apply() end

    local vVal = controller.getLeftY()
    if vVal > 0.5 or controller.isDPDown() then settings.moveRow(1)
    elseif vVal < -0.5 or controller.isDPUp() then settings.moveRow(-1) end

    local hVal = controller.getLeftX()
    if hVal > 0.5 or controller.isDPRight() then settings.moveH(1)
    elseif hVal < -0.5 or controller.isDPLeft() then settings.moveH(-1) end
end

function settings.moveH(dir)
    if settings.moveTimeout > 0 then return end
    settings.moveTimeout = config.ui.moveTimeout

    if settings.selectedRow == 1 then settings.moveResolution(dir)
    elseif settings.selectedRow == 2 then settings.fullscreen = not settings.fullscreen end
end

function settings.moveRow(dir)
    if settings.moveTimeout > 0 then return end
    settings.moveTimeout = config.ui.moveTimeout

    settings.selectedRow = settings.selectedRow + dir
    if settings.selectedRow < 1 then settings.selectedRow = 1
    elseif settings.selectedRow > 2 then settings.selectedRow = 2 end
end

function settings.drawButtonPrompts()
    love.graphics.setFont(fonts.place)
    love.graphics.push()
    love.graphics.translate(520, 0)
    love.graphics.circle('fill', 25, 45, 10)
    love.graphics.setColor(0.2, 0.8, 0.2)
    love.graphics.draw(sprites.ui_A, 0, 20)
    love.graphics.setColor(1, 1, 1, 1)
    fonts.outlineText('Apply', 50, 15, 800, 'left')
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle('fill', 325, 45, 10)
    love.graphics.setColor(0.8, 0.8, 0.2)
    love.graphics.draw(sprites.ui_Y, 300, 20)
    love.graphics.setColor(1, 1, 1, 1)
    
    fonts.outlineText('Main Menu', 350, 15, 800, 'left')
    love.graphics.pop()
end

function settings.getResolutionIndex()
    local w = config.window.width
    local h = config.window.height
    for i, res in ipairs(settings.resolutions) do
        if res.width == w and res.height == h then return i end
    end
    return 1
end

function settings.moveResolution(dir)
    settings.resolutionIndex = settings.resolutionIndex + dir
    if settings.resolutionIndex > #settings.resolutions then settings.resolutionIndex = 1
    elseif settings.resolutionIndex < 1 then settings.resolutionIndex = #settings.resolutions end
end

function settings.drawResolution()
    local w = settings.resolutions[settings.resolutionIndex].width
    local h = settings.resolutions[settings.resolutionIndex].height
    if settings.selectedRow == 1 then
        love.graphics.draw(sprites.ui_timeselector, config.video.width / 2, 0, -math.pi / 2, 1, 1, 60, modeselector.oy)
    end
    love.graphics.setFont(fonts.place)
    fonts.outlineText('Resolution: ', 0, 0, config.video.width / 2 - 10, 'right')
    fonts.outlineText(tostring(w) .. ' x ' .. tostring(h), config.video.width / 2 + 10, 0, config.video.width, 'left')
    love.graphics.translate(0, settings.spacing)
end

function settings.drawFullscreen()
    if settings.selectedRow == 2 then
        love.graphics.draw(sprites.ui_timeselector, config.video.width / 2, 0, -math.pi / 2, 1, 1, 60, modeselector.oy)
    end
    love.graphics.setFont(fonts.place)
    fonts.outlineText('Fullscreen: ', 0, 0, config.video.width / 2 - 10, 'right')
    fonts.outlineText(tostring(settings.fullscreen), config.video.width / 2 + 10, 0, config.video.width, 'left')
    love.graphics.translate(0, settings.spacing)
end