game = {scoringMode = 'points'} -- scoringMode = points | places

function game.load()
    level.create()
    ships.create({A = 'green', B = 'red'})
    screens.create()
end

function game.start()
    countdown.start(config.game.roundTime)
    sounds.playBGM()
end

function game.draw()
    screens.draw(game.screenDraw)
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