local function otf(url, size)
    return love.graphics.newFont('assets/font/' .. url .. '.otf', size)
end

fonts = {
    title = otf('chomsky', 32),
    main = otf('some_time_later', 16),
    place = otf('chomsky', 40),
    default = love.graphics.newFont(12),
}
fonts.countdown = fonts.place