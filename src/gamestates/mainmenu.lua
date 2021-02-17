mainmenu = {
    waiting = true,
    timeout = 60,
    blinkFrames = 0,
}

mainmenu.title = {
    x = 0,
    y = 0,
    r = 0,
    text = 'Galleons',
    angleX = love.math.random() * math.pi,
    angleY = love.math.random() * math.pi,
    angleR = love.math.random() * math.pi,
}

mainmenu.buttons = {
    {icon = sprites.ui_A, color={r=0.2, g=0.8, b=0.2}, text = 'Play', y = config.video.height / 2 - 150},
    {icon = sprites.ui_B, color={r=0.8, g=0.2, b=0.2}, text = 'Settings', y = config.video.height / 2},
    {icon = sprites.ui_X, color={r=0.2, g=0.2, b=0.8}, text = 'Quit', y = config.video.height / 2 + 150},
}

function mainmenu.load()
    background.create()
end

function mainmenu.start()
    sounds.playAmbience()
end

function mainmenu.stop()
end

function mainmenu.draw()
    background.draw()
    mainmenu.drawTitle(mainmenu.title)

    if mainmenu.waiting then mainmenu.drawConnectPrompt()
    else mainmenu.drawButtons() end
end

function mainmenu.drawButtons()
    for i, button in ipairs(mainmenu.buttons) do
        mainmenu.drawSingleButton(button)
    end
end

function mainmenu.drawSingleButton(button)
    love.graphics.setFont(fonts.result)
    local w2 = fonts.result:getWidth(button.text) / 2
    fonts.outlineText(button.text, 0, button.y, config.video.width, 'center')
    love.graphics.circle('fill', config.video.width / 2 - w2 - 25, button.y + 48, 14)
    love.graphics.setColor(button.color.r, button.color.g, button.color.b)
    love.graphics.draw(button.icon, config.video.width / 2 - w2 - 50, button.y + 24)
    love.graphics.setColor(1, 1, 1, 1)
end

function mainmenu.drawConnectPrompt()
    if mainmenu.blinkFrames > 40 then return end
    love.graphics.setFont(fonts.result)
    fonts.outlineText('Press any button to start!', 0, config.video.height / 2, config.video.width, 'center')
end

function mainmenu.drawTitle(title)
    love.graphics.push()
    love.graphics.setFont(fonts.title)
    love.graphics.rotate(title.r)
    fonts.outlineText(title.text, title.x, title.y, title.x + config.video.width, 'center')
    love.graphics.pop()
end

function mainmenu.update(dt)
    background.update()
    mainmenu.updateTitle(mainmenu.title)

    if controller.A ~= nil then mainmenu.waiting = false
    else mainmenu.waiting = true end

    mainmenu.handleButtons()
    mainmenu.blinkFrames = mainmenu.blinkFrames + 1
    if mainmenu.blinkFrames > 60 then mainmenu.blinkFrames = 0 end
end

function mainmenu.updateTitle(title)
    title.x = math.sin(title.angleX) * 10
    title.y = math.sin(title.angleY) * 10
    title.r = math.sin(title.angleR) * 0.01
    title.angleX = title.angleX + 0.01
    title.angleY = title.angleY + 0.011
    title.angleR = title.angleR + 0.012
end

function mainmenu.handleButtons()
    if mainmenu.waiting then return 
    else mainmenu.timeout = decrease(mainmenu.timeout) end
    
    if mainmenu.timeout > 0 then return end
    if controller.A.isADown() then
        gamestates.setActive(pregame)
    elseif controller.A.isBDown() then
        -- go to settings
    elseif controller.A.isXDown() then
        love.event.quit()
    end
end