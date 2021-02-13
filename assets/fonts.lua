local function otf(url, size)
    return love.graphics.newFont('assets/font/' .. url .. '.otf', size)
end

fonts = {
    title = otf('chomsky', 32),
    normal = otf('chomsky', 32),
    place = otf('chomsky', 40),
    default = love.graphics.newFont(12),
}
fonts.countdown = fonts.place

fonts.black = sprites.colorFromName.black