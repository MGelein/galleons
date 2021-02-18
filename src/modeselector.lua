modeselector = {
    mode = '',
    time = 300,
    y = -5000,
    ty = -5000,
    timeout = 60,
    xtimeout = 0,
    btimeout = 0,
    ox = sprites.ui_playerselector_bg:getWidth(),
    oy = sprites.ui_playerselector_bg:getHeight() / 2,
}

-- gamemode (B)
-- playtime (X)

function modeselector.create()
    modeselector.mode = game.deathmatch
    modeselector.mins = 5
end

function modeselector.draw()
    local hw2 = config.video.width / 2
    modeselector.y = modeselector.y + (modeselector.ty - modeselector.y) * 0.1
    love.graphics.push()
    love.graphics.translate(0, modeselector.y)

    love.graphics.draw(sprites.ui_playerselector_bg, config.video.width / 2, 100, -math.pi / 2, 1, 1, modeselector.ox, modeselector.oy)

    love.graphics.push()
    love.graphics.translate(config.video.width / 2 - modeselector.oy + 10, 105)
    love.graphics.circle('fill', 24, 24, 14)
    love.graphics.setColor(0.2, 0.2, 0.8)
    love.graphics.draw(sprites.ui_X, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
    
    love.graphics.setFont(fonts.place)
    fonts.outlineText('Gamemode: ' .. modeselector.getModeString(), 0, 100, config.video.width, 'center')
    love.graphics.setFont(fonts.normal)
    fonts.outlineText(modeselector.getModeExplanation(), hw2 - modeselector.oy + 10, 180, hw2 - 230, 'center')


    love.graphics.translate(0, modeselector.ox + 20)
    love.graphics.draw(sprites.ui_timeselector, config.video.width / 2, 100, -math.pi / 2, 1, 1, 60, modeselector.oy)

    love.graphics.push()
    love.graphics.translate(config.video.width / 2 - modeselector.oy + 10, 105)
    love.graphics.circle('fill', 24, 24, 14)
    love.graphics.setColor(0.8, 0.2, 0.2)
    love.graphics.draw(sprites.ui_B, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()

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
        modeselector.xtimeout = decrease(modeselector.xtimeout)
        modeselector.btimeout = decrease(modeselector.btimeout)
        modeselector.ty = 150
        if controller.A ~= nil then
            if controller.A.isADown() and modeselector.timeout == 0 then
                pregame.modeSet()
            end

            if controller.A.isXDown() and modeselector.xtimeout == 0 then
                modeselector.nextMode()
            end

            if controller.A.isBDown() and modeselector.btimeout == 0 then
                modeselector.nextTime()
            end
        end
    else
        modeselector.ty = -5000
    end
end

function modeselector.nextMode()
    if modeselector.mode == game.deathmatch then modeselector.mode = game.kingOfTheHill
    elseif modeselector.mode == game.kingOfTheHill then modeselector.mode = game.captureTheFlag
    else modeselector.mode = game.deathmatch end
    modeselector.xtimeout = config.ui.moveTimeout
end

function modeselector.nextTime()
    modeselector.mins = modeselector.mins + 1
    if modeselector.mins > 10 then modeselector.mins = 1 end
    modeselector.btimeout = config.ui.moveTimeout
end