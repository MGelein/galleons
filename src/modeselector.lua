modeselector = {
    mode = '',
    time = 300,
}

-- gamemode (B)
-- playtime (X)

function modeselector.create()
    modeselector.mode = game.deathmatch
end

function modeselector.draw()

end

function modeselector.updateRoundTime()
    if mode == game.deathmatch then config.game.matchTime = modeselector.time
    elseif mode == game.kingOfTheHill then config.game.kothTime = modeSelector.time
    elseif mode == game.captureTheFlag then  config.game.ctfTime = modeSelector.time 
    end
end

function modeselector.update()
    if not pregame.gameModeSelected then
        if controller.A ~= nil then
            if controller.A.isADown() then
                pregame.modeSet()
            end
        end
    end
end