controller = {}
controller.requireRegistration = true
controller.unregistered = {}
controller.newlyRegistered = {}

function love.joystickadded(joystick)
    if controller.requireRegistration then
        table.insert(controller.unregistered, joystick)
    else
        controller.register(joystick)
    end
end

function love.joystickremoved(joystick)
    local foundIndex = -1
    for i, unregisteredJoystick in ipairs(controller.unregistered) do
        if unregisteredJoystick == joystick then
            foundIndex = i
            break
        end
    end
    if foundIndex > -1 then 
        table.remove(controller.unregistered, foundIndex)
        return
    end

    for letter, control in pairs(controller) do
        if #letter == 1 then
            if control.joystick == joystick then
                controller[letter] = nil
            end
        end
    end
end

function controller.register(js)
    local letter = 'A'
    for i = 1, 26 do
        if controller[letter] == nil then break end
        letter = string.char(64 + i)
    end
    
    controller[letter] = {
        joystick = js,
        getLeftX = function() return js:getAxis(1) end,
        getLeftY = function() return js:getAxis(2) end,
        getLeftTrigger = function() return js:getAxis(3) end,
        getRightX = function() return js:getAxis(4) end,
        getRightY = function() return js:getAxis(5) end,
        getRightTrigger = function() return js:getAxis(6) end,
        
        isADown = function() return js:isDown(1) end,
        isBDown = function() return js:isDown(2) end,
        isXDown = function() return js:isDown(3) end,
        isYDown = function() return js:isDown(4) end,
        isLeftShoulderDown = function() return js:isDown(5) end,
        isRightShoulderDown = function() return js:isDown(6) end,
        isViewDown = function() return js:isDown(7) end,
        isMenuDown = function() return js:isDown(8) end,
        isLeftStickDown = function() return js:isDown(9) end,
        isRightStickDown = function() return js:isDown(10) end,
        
        isDPUp = function()
            local dp = js:getHat(1)
            return (dp == 'u' or dp == 'lu' or dp=='ru') 
        end,
        isDPLeft = function()
            local dp = js:getHat(1)
            return (dp == 'l' or dp == 'lu' or dp=='ld') 
        end,
        isDPRight = function()
            local dp = js:getHat(1)
            return (dp == 'r' or dp == 'ru' or dp=='rd') 
        end,
        isDPDown = function()
            local dp = js:getHat(1)
            return (dp == 'd' or dp == 'ld' or dp=='rd') 
        end
    }
end

function love.joystickpressed(joystick, button)
    if #controller.unregistered < 1 then return end

    for letter, control in pairs(controller) do
        if #letter == 1 then
            if control.joystick == joystick then return end
        end
    end

    controller.register(joystick)
    local foundIndex = -1
    for j, unregisteredJoystick in ipairs(controller.unregistered) do
        if joystick == unregisteredJoystick then
            foundIndex = j
            break
        end
    end
    if foundIndex ~= -1 then table.remove(controller.unregistered, foundIndex) end
end

function controller.exists(letter)
    return controller[letter] ~= nil
end