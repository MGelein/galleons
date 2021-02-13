animations = {
    explosion = {
        frames = {sprites.explosion1, sprites.explosion2, sprites.explosion3}, 
        speed = 3,
    },

    fire = {
        frames = {sprites.fire1, sprites.fire2},
        speed = 3,
    },

    blackShip = {
        frames = {sprites.black_full, sprites.black_light, sprites.black_heavy, sprites.black_dead},
        speed = 3,
    },

    whiteShip = {
        frames = {sprites.white_full, sprites.white_light, sprites.white_heavy, sprites.white_dead},
        speed = 3,
    },

    redShip = {
        frames = {sprites.red_full, sprites.red_light, sprites.red_heavy, sprites.red_dead},
        speed = 3,
    },

    blueShip = {
        frames = {sprites.blue_full, sprites.blue_light, sprites.blue_heavy, sprites.blue_dead},
        speed = 3,
    },

    greenShip = {
        frames = {sprites.green_full, sprites.green_light, sprites.green_heavy, sprites.green_dead},
        speed = 3,
    },

    yellowShip = {
        frames = {sprites.yellow_full, sprites.yellow_light, sprites.yellow_heavy, sprites.yellow_dead},
        speed = 3,
    },

    uiHeart = {
        frames = {sprites.heart_empty, sprites.heart_quarter, sprites.heart_half, sprites.heart_three_quarters, sprites.heart_full},
        speed = 0,
    },

    clouds = {
        frames = {sprites.cloud1, sprites.cloud2, sprites.cloud3},
        speed = 0,
    }
}

animations.shipFromColor = {
    yellow = animations.yellowShip,
    white = animations.whiteShip,
    red = animations.redShip,
    blue = animations.blueShip,
    green = animations.greenShip,
    black = animations.blackShip
}