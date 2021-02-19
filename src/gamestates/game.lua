game = {
    running = false,
    players = {A = 'green', B = 'red'},
    alerts = {},
    deathmatch = 'deathmatch',
    kingOfTheHill = 'kingofthehill',
    captureTheFlag = 'captureTheFlag'
} 
game.startAlerts = {}
game.startAlerts[game.deathmatch] = 'Fight!'
game.startAlerts[game.captureTheFlag] = 'Steal!'
game.startAlerts[game.kingOfTheHill] = 'Conquer!'
game.mode = game.deathmatch
game.roundTime = config.game.kothTime

-- IDEAS FOR GAMEMODES
-- Treasure Hunt (robbing merchants and other players or finding coins?)

function game.load()
    level.create()
    ships.create(game.players)
    screens.create()

    if config.useGameCountdown then
        game.queueAlert('3', 1)
        game.queueAlert('2', 1)
        game.queueAlert('1', 1)
        game.queueAlert(game.startAlerts[game.mode], 1)
    else
        game.running = true
    end
end

function game.start()
    countdown.start(game.roundTime)
    sounds.playBGM()
end

function game.stop()
    game.running = false
    postgame.results = game.gatherResults()
    gamestates.setActive(postgame)
end

function game.draw()
    screens.draw(game.screenDraw)
    if #game.alerts > 0 then game.drawAlert(game.alerts[1]) end
end

function game.screenDraw(screen)
    level.draw(screen)
    splash.draw()
    powerups.draw()
    mines.draw()
    flags.draw()
    ships.draw()
    bullets.draw()
    smoke.draw()
    explosions.draw()
    tornadoes.draw()
end

function game.update(dt)
    screens.update()
    splash.update()
    ships.update()
    bullets.update()
    smoke.update()
    explosions.update()
    powerups.update()
    mines.update()
    tornadoes.update()
    level.update()
    flags.update()

    if #game.alerts > 0 then
        game.alerts[1].time = game.alerts[1].time - dt
        if game.alerts[1].time <= 0 then 
            table.remove(game.alerts, 1)

            if #game.alerts == 0 and not game.running then
                game.running = true
            end
        end
    end
    
    if game.mode == game.deathmatch or game.mode == game.kingOfTheHill then
        game.setUIScores()
    else
        game.calculatePlaceOrder()
    end
end

function game.setUIScores()
    for i, ship in ipairs(ships.list) do
        ships.setUIScore(ship)
    end
end

function game.calculatePlaceOrder()
    local inOrder = {ships.list[1]}
    for i=2, #ships.list do
        local ship = ships.list[i]
        local inserted = false
        for j=1, #inOrder do
            local oldShip = inOrder[j]
            if ship.score > oldShip.score then
                table.insert(inOrder, j, ship) -- Bad argument #2 number expected, got table
                inserted = true
                break
            end
        end
        if not inserted then table.insert(inOrder, ship) end
    end
    local place = 1
    local prevShip = inOrder[1]
    for i, ship in ipairs(inOrder) do
        if ship.score ~= prevShip.score then
            place = place + 1
        end
        ships.setPlace(ship, place)
    end
    return inOrder
end

function game.queueAlert(alert, seconds)
    table.insert(game.alerts, {
        text = alert, 
        time = seconds, 
        origTime = seconds, 
        y = -2000
    })
end

function game.drawAlert(alert)
    alert.y = ((config.video.height / 2 - 100) - alert.y) * 0.2 + alert.y
    love.graphics.setFont(fonts.alert)
    fonts.outlineText(alert.text, 0, alert.y, config.video.width, 'center')
end

function game.gatherResults()
    local results = {}
    local inOrder = game.calculatePlaceOrder()
    for i, ship in ipairs(inOrder) do
        local result = {
            score = ship.score,
            player = ship.letter,
            color = ship.namedColor,
            place = gui.getPlaceName(ship.canvas.ui.scoreValue)
        }
        table.insert(results, result)
    end
    return results
end

function game.cleanup()
    bullets.removeAll()
    explosions.removeAll()
    mines.removeAll()
    powerups.removeAll()
    ships.removeAll()
    spawns.removeAll()
    splash.removeAll()
    tornadoes.removeAll()
    sounds.stopBGM()
end