modeselector = {
    mode = '',
    time = 300,
    y = -5000,
    ty = -5000,
    timeout = 60,
    moveTimeout = 0,
    ox = sprites.ui_playerselector_bg:getWidth(),
    oy = sprites.ui_playerselector_bg:getHeight() / 2,
    selectedRow = 1,
    modeIndex = 1,
    timeIndex = 1,
    times = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
}

-- gamemode (B)
-- playtime (X)

function modeselector.create()
    modeselector.modes = {game.deathmatch, game.captureTheFlag, game.kingOfTheHill}
    modeselector.mode = game.deathmatch
    modeselector.mins = 5
end

function modeselector.draw()
    local hw2 = config.video.width / 2
    modeselector.y = modeselector.y + (modeselector.ty - modeselector.y) * 0.1
    love.graphics.push()
    love.graphics.translate(0, modeselector.y)

    if modeselector.selectedRow == 1 then
        love.graphics.draw(sprites.ui_playerselector_bg, config.video.width / 2, 100, -math.pi / 2, 1, 1, modeselector.ox, modeselector.oy)
    end

    love.graphics.setFont(fonts.place)
    fonts.outlineText('Gamemode: ' .. modeselector.getModeString(), 0, 100, config.video.width, 'center')
    love.graphics.setFont(fonts.normal)
    fonts.outlineText(modeselector.getModeExplanation(), hw2 - modeselector.oy + 10, 180, hw2 - 230, 'center')


    love.graphics.translate(0, modeselector.ox + 20)
    if modeselector.selectedRow == 2 then
        love.graphics.draw(sprites.ui_timeselector, config.video.width / 2, 100, -math.pi / 2, 1, 1, 60, modeselector.oy)
    end

    love.graphics.setFont(fonts.place)
    fonts.outlineText('Time: ' .. tostring(modeselector.mins) .. ' minutes', 0, 100, config.video.width, 'center')
    
    love.graphics.pop()
end

function modeselector.getModeString()
    if modeselector.mode == game.deathmatch then return "Deathmatch"
    elseif modeselector.mode == game.captureTheFlag then return "Capture the flag"
    elseif modeselector.mode == game.kingOfTheHill then return "King of the hill"
    end
end

function modeselector.getModeExplanation()
    if modeselector.mode == game.deathmatch then
        return "All players fight for the duration of the match. Every kill is worth one point. Whoever ends with the most points wins."
    elseif modeselector.mode == game.captureTheFlag then
        return "Every player base has a flag. The player who manages to collect all flags at their own base wins."
    elseif modeselector.mode == game.kingOfTheHill then
        return "The player who is alone at the center as the match ends wins. Time only counts down if one player is in the center."
    end
end

function modeselector.updateRoundTime()
    if mode == game.deathmatch then config.game.matchTime = modeselector.mins * 60
    elseif mode == game.kingOfTheHill then config.game.kothTime = modeSelector.mins * 60
    elseif mode == game.captureTheFlag then  config.game.ctfTime = modeSelector.mins * 60
    end
    return modeselector.mins * 60
end

function modeselector.update()
    if not pregame.gameModeSelected then
        modeselector.timeout = decrease(modeselector.timeout)
        modeselector.moveTimeout = decrease(modeselector.moveTimeout)
        modeselector.ty = 150
        if controller.A ~= nil then
            if controller.A.isADown() and modeselector.timeout == 0 then
                pregame.modeSet()
            end

            local vVal = controller.A.getLeftY()
            local hVal = controller.A.getLeftX()
            if vVal < -0.5 or controller.A.isDPUp() then modeselector.selectedRow = 1
            elseif vVal > 0.5 or controller.A.isDPDown() then modeselector.selectedRow = 2 end

            if hVal > 0.5 or controller.A.isDPRight() then modeselector.move(1)
            elseif hVal < -0.5 or controller.A.isDPLeft() then modeselector.move(-1) end
        end
    else
        modeselector.ty = -5000
    end
end

function modeselector.move(dir)
    if modeselector.moveTimeout > 0 then return
    else modeselector.moveTimeout = config.ui.moveTimeout end

    if modeselector.selectedRow == 1 then modeselector.moveMode(dir)
    elseif modeselector.selectedRow == 2 then modeselector.moveTime(dir) end
end

function modeselector.moveMode(dir)
    modeselector.modeIndex = modeselector.modeIndex + dir
    if modeselector.modeIndex > #modeselector.modes then modeselector.modeIndex = 1
    elseif modeselector.modeIndex < 1 then modeselector.modeIndex = #modeselector.modes end
    modeselector.mode = modeselector.modes[modeselector.modeIndex]
end

function modeselector.moveTime(dir)
    modeselector.timeIndex = modeselector.timeIndex + dir
    if modeselector.timeIndex > #modeselector.times then modeselector.timeIndex = 1
    elseif modeselector.timeIndex < 1 then modeselector.timeIndex = #modeselector.times end
    modeselector.mins = modeselector.times[modeselector.timeIndex]
end