function decrease(value)
    if value <= 0 then return value
    else return value - 1 end
end

function padZero(value)
    if value < 10 then return '0' .. value end
    return value
end

function toDir(value)
    if value > 0 then return -math.pi2
    else return math.pi2 end
end

function toDirs(value, machinegunFrames)
    if machinegunFrames > 0 then return {1, -1}
    else 
        if value > 0 then return {1}
        else return {-1} end
    end
end