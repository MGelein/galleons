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
        {width = 1920, height = 1080},
        {width = 2048, height = 1152},
        {width = 2560, height = 1440},
    },
    resolutionIndex = 1,
    fullscreen = config.window.fullscreen,
    fxMult = 0.2,
    ambienceMult = 0.5,
    musicMult = 1,
}

function settings.load()
    background.create()
    settings.read()
end

function settings.read()
    settings.resolutionIndex = settings.getResolutionIndex()
    settings.fxMult = config.audio.fxMult
    settings.musicMult = config.audio.musicMult
    settings.ambienceMult = config.audio.ambienceMult
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
    settings.drawSlider('Music Volume: ', settings.musicMult, 3)
    settings.drawSlider('Ambience Volume: ', settings.ambienceMult, 4)
    settings.drawSlider('Effects Volume: ', settings.fxMult, 5)
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
    config.audio.fxMult = settings.fxMult
    config.audio.musicMult = settings.musicMult
    config.audio.ambienceMult = settings.ambienceMult
    settings.read()
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
    elseif settings.selectedRow == 2 then settings.fullscreen = not settings.fullscreen
    elseif settings.selectedRow == 3 then settings.moveMusicMult(dir)
    elseif settings.selectedRow == 4 then settings.moveAmbienceMult(dir)
    elseif settings.selectedRow == 5 then settings.moveFXMult(dir) end
end

function settings.moveFXMult(dir)
    settings.fxMult = settings.fxMult + dir * 0.05
    if settings.fxMult < 0 then settings.fxMult = 0
    elseif settings.fxMult > 1 then settings.fxMult = 1 end
    config.audio.fxMult = settings.fxMult
    sounds.updateVolumes()
end

function settings.moveMusicMult(dir)
    settings.musicMult = settings.musicMult + dir * 0.05
    if settings.musicMult < 0 then settings.musicMult = 0
    elseif settings.musicMult > 1 then settings.musicMult = 1 end
    config.audio.musicMult = settings.musicMult
    sounds.updateVolumes()
end

function settings.moveAmbienceMult(dir)
    settings.ambienceMult = settings.ambienceMult + dir * 0.05
    if settings.ambienceMult < 0 then settings.ambienceMult = 0
    elseif settings.ambienceMult > 1 then settings.ambienceMult = 1 end
    config.audio.ambienceMult = settings.ambienceMult
    sounds.updateVolumes()
end

function settings.moveRow(dir)
    if settings.moveTimeout > 0 then return end
    settings.moveTimeout = config.ui.moveTimeout

    settings.selectedRow = settings.selectedRow + dir
    if settings.selectedRow < 1 then settings.selectedRow = 1
    elseif settings.selectedRow > 5 then settings.selectedRow = 5 end
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
    print(w, h)
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
        love.graphics.draw(sprites.ui_timeselector, config.video.width / 2, 0, -math.pi / 2, 1, 1.25, 60, modeselector.oy)
    end
    love.graphics.setFont(fonts.place)
    fonts.outlineText('Resolution: ', 0, 0, config.video.width / 2 - 10, 'right')
    fonts.outlineText(tostring(w) .. ' x ' .. tostring(h), config.video.width / 2 + 10, 0, config.video.width, 'left')
    love.graphics.translate(0, settings.spacing)
end

function settings.drawFullscreen()
    if settings.selectedRow == 2 then
        love.graphics.draw(sprites.ui_timeselector, config.video.width / 2, 0, -math.pi / 2, 1, 1.25, 60, modeselector.oy)
    end
    love.graphics.setFont(fonts.place)
    fonts.outlineText('Fullscreen: ', 0, 0, config.video.width / 2 - 10, 'right')
    fonts.outlineText(tostring(settings.fullscreen), config.video.width / 2 + 10, 0, config.video.width, 'left')
    love.graphics.translate(0, settings.spacing)
end

function settings.drawSlider(name, value, row)
    if settings.selectedRow == row then
        love.graphics.draw(sprites.ui_timeselector, config.video.width / 2, 0, -math.pi / 2, 1, 1.25, 60, modeselector.oy)
    end
    love.graphics.setFont(fonts.place)
    fonts.outlineText(name, 0, 0, config.video.width / 2 - 10, 'right')
    local left = config.video.width / 2 + 10
    love.graphics.rectangle('line', left, 20, config.video.width / 5, 25)
    love.graphics.rectangle('fill', left, 20, (config.video.width / 5) * value, 25)
    love.graphics.translate(0, settings.spacing)
end