modeselector = {}

-- gamemode (B)
-- playtime (X)

function modeselector.create()

end

function modeselector.draw()

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