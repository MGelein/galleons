local function png(url)
    return love.graphics.newImage("assets/" .. url .. ".png")
end

sprites = {

    ui_tile = png("ui/tile"),
    ui_tile_wide = png("ui/tile_broad"),
    ui_tile_large = png("ui/tile_broad"),
    ui_minimap_bg = png("ui/minimap_bg"),
    ui_tileR1 = png("ui/tileR1overlay"),
    ui_cannonball = png("ui/cannonball"),
    pu_health = png("ui/pu_health"),
    pu_mine = png("ui/pu_mine"),
    pu_machinegun = png("ui/pu_machinegun"),
    pu_turbo = png("ui/pu_turbo"),
    ui_A = png("ui/buttonA"),
    ui_B = png("ui/buttonB"),
    ui_X = png("ui/buttonX"),
    ui_Y = png("ui/buttonY"),
    ui_L = png("ui/buttonL"),
    ui_L1 = png("ui/buttonL1"),
    ui_R = png("ui/buttonR"),
    ui_R1 = png("ui/buttonR1"),
    heart_full = png("ui/full_heart"),
    heart_three_quarters = png("ui/threeq_heart"),
    heart_half = png("ui/half_heart"),
    heart_quarter = png("ui/quarter_heart"),
    heart_empty = png("ui/empty_heart"),

    seabg= png("seabg"),

    cannon = png("cannon/cannon"),
    mountedCannon = png("cannon/cannon_mounted"),
    looseCannon = png("cannon/cannon_unmounted"),
    cannonBall = png("cannon/ball"),
    cannonRow = png("cannon/row"),
    
    explosion1 = png("fx/explosion1"),
    explosion2 = png("fx/explosion2"),
    explosion3 = png("fx/explosion3"),
    
    fire1 = png("fx/fire1"),
    fire2 = png("fx/fire2"),

    baseA = png('structures/base1'),
    baseB = png('structures/base2'),
    baseC = png('structures/base3'),
    baseD = png('structures/base4'),

    crate = png('cannon/crate'),
    mine = png('cannon/mine'),

    black_dead = png("ships/black_dead"),
    black_full = png("ships/black_full"),
    black_heavy = png("ships/black_heavy"),
    black_light = png("ships/black_light"),
    blue_dead = png("ships/blue_dead"),
    blue_full = png("ships/blue_full"),
    blue_heavy = png("ships/blue_heavy"),
    blue_light = png("ships/blue_light"),
    green_dead = png("ships/green_dead"),
    green_full = png("ships/green_full"),
    green_heavy = png("ships/green_heavy"),
    green_light = png("ships/green_light"),
    red_dead = png("ships/red_dead"),
    red_full = png("ships/red_full"),
    red_heavy = png("ships/red_heavy"),
    red_light = png("ships/red_light"),
    white_dead = png("ships/white_dead"),
    white_full = png("ships/white_full"),
    white_heavy = png("ships/white_heavy"),
    white_light = png("ships/white_light"),
    yellow_dead = png("ships/yellow_dead"),
    yellow_full = png("ships/yellow_full"),
    yellow_heavy = png("ships/yellow_heavy"),
    yellow_light = png("ships/yellow_light"),

    debug_background = png("ui/debug"),

    base1 = png("structures/base1"),
    base2 = png("structures/base2"),
    base3 = png("structures/base3"),
    base4 = png("structures/base4"),
}

sprites.colorFromName = {
    white = {r = 1, g = 0.95, b = 0.82},
    yellow = {r = 0.91, g = 0.73, b = 0.14},
    red = {r = 0.85, g = 0, b = 0},
    blue = {r = 0.44, g = 0.6, b = 0.75},
    green = {r = 0.46, g = 0.74, b = 0.31},
    black = {r = 0.37, g = 0.45, b = 0.45}
}