mainmenu = {
    waiting = true,
    timeout = 60,
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

-- Play (A)
-- Settings (B)
-- Quit (X)

function mainmenu.load()
    background.create()
end

function mainmenu.start()
end

function mainmenu.stop()
end

function mainmenu.draw()
    background.draw()
    mainmenu.drawTitle(mainmenu.title)
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