gamestates = {}
gamestates.game = {scoringMode = 'points'} -- scoringMode = points | places
gamestates.mainmenu = {}
gamestates.playermenu = {}
gamestates.gamemenu = {}

function gamestates.game.load()
    level.create()
    ships.create({A = 'green', B = 'red'})
    -- ships.create({A = 'green', B = 'red', C = 'yellow', D = 'blue'})
    screens.create()
    countdown.start(config.game.roundTime)
end

function gamestates.game.draw()
    screens.draw(gamestates.game.screenDraw)
end

function gamestates.game.screenDraw(screen)
    level.draw(screen)
    splash.draw()
    powerups.draw()
    mines.draw()
    ships.draw()
    bullets.draw()
    explosions.draw()
end

function gamestates.game.update(dt)
    screens.update()
    splash.update()
    ships.update()
    bullets.update()
    explosions.update()
    powerups.update()
    mines.update()
    
    if gamestates.game.scoringMode == 'places' then
        gamestates.game.calculatePlaceOrder()
    else
        gamestates.game.setUIScores()
    end
end

function gamestates.game.setUIScores()
    for i, ship in ipairs(ships.list) do
        ships.setUIScore(ship)
    end
end

function gamestates.game.calculatePlaceOrder()
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

function gamestates.setActive(newState)
    gamestates.active = newState
    newState.load()
end

gamestates.setActive(gamestates.game)