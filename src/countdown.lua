countdown = {s = 1, scaleAcc = 0}
countdown.sprite = sprites.ui_tile_wide
countdown.timeString = "99:99"
countdown.ox = countdown.sprite:getWidth() / 2
countdown.oy = countdown.sprite:getHeight() / 2

function countdown.calculatePosition()
    if #screens.list == 1 then
        countdown.x = screens.list[1].w2
        countdown.y = screens.list[1].h - countdown.oy - 10
        return
    end

    local sumX = 0
    local sumY = 0
    for i, screen in ipairs(screens.list) do
        sumX = sumX + screen.x
        sumY = sumY + screen.y
    end
    countdown.x = sumX / #screens.list + screens.list[1].w2
    countdown.y = sumY / #screens.list + screens.list[1].h2
end

function countdown.draw()
    love.graphics.draw(countdown.sprite, countdown.x, countdown.y, 0, countdown.s, countdown.s, countdown.ox, countdown.oy)
    love.graphics.setFont(fonts.countdown)
    love.graphics.setColor(fonts.black.r, fonts.black.g, fonts.black.b, 1)
    love.graphics.print(countdown.timeString, countdown.x - countdown.ox + 20, countdown.y - countdown.oy + 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(countdown.timeString, countdown.x - countdown.ox + 19, countdown.y - countdown.oy + 9)
end

function countdown.update()
    countdown.s = countdown.s + countdown.scaleAcc
    countdown.scaleAcc = countdown.scaleAcc * 0.95
    countdown.s = (1 - countdown.s) * 0.3 + countdown.s
    if countdown.s < 1.01 then countdown.s = 1 end
    
    countdown.timeLeft = countdown.timeLeft - love.timer.getDelta()
    if countdown.timeLeft < 0 then game.stop() end
    local prevMinutes = countdown.minutes
    countdown.minutes = math.floor(countdown.timeLeft / 60)
    if countdown.minutes < 0 then return end
    local prevSeconds = countdown.seconds
    countdown.seconds = math.floor(countdown.timeLeft - countdown.minutes * 60)
    countdown.timeString = padZero(countdown.minutes) .. ':' .. padZero(countdown.seconds)

    if countdown.seconds ~= prevSeconds and countdown.timeLeft < 10 then
        countdown.breathe() 
    elseif countdown.minutes ~= prevMinutes then
        countdown.breathe()
    end
end

function countdown.breathe()
    countdown.scaleAcc = 0.1
end

function countdown.start(amount)
    countdown.startTime = amount
    countdown.timeLeft = amount
end