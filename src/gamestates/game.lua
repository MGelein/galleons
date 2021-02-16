game = {
    scoringMode = 'points', -- scoringMode = points | places | coins
    running = false,
    players = {A = 'green', B = 'red'},
    alerts = {}
} 

-- IDEAS FOR GAMEMODES
-- Capture the flag
-- King of the hill
-- Deathmatch
-- Treasure Hunt (robbing merchants and other players or finding coins?)
-- Races?

function game.load()
    level.create()
    ships.create(game.players)
    screens.create()

    game.queueAlert('3', 1)
    game.queueAlert('2', 1)
    game.queueAlert('1', 1)
    game.queueAlert('Fight!', 1)
end

function game.start()
    countdown.start(config.game.roundTime)
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
    ships.draw()
    bullets.draw()
    explosions.draw()
    tornadoes.draw()
end

function game.update(dt)
    screens.update()
    splash.update()
    ships.update()
    bullets.update()
    explosions.update()
    powerups.update()
    mines.update()
    tornadoes.update()

    if #game.alerts > 0 then
        game.alerts[1].time = game.alerts[1].time - dt
        if game.alerts[1].time <= 0 then 
            table.remove(game.alerts, 1)

            if #game.alerts == 0 and not game.running then
                game.running = true
            end
        end
    end
    
    if game.scoringMode == 'places' then
        game.calculatePlaceOrder()
    else
        game.setUIScores()
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
                table.insert(inOrder, ship, j)
                inserted = true
                break
            end
        end
        if not inserted then table.insert(inOrder, ship) end
    end
    for i=1, #inOrder do
        ships.setPlace(inOrder[i], i)
    end
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
    game.calculatePlaceOrder()
    for i, ship in ipairs(ships.list) do
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