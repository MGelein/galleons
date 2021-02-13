config = {
    window = {
        width = 1600,
        height = 900,
        title = 'Galleons',
        fullscreen = false,
        dpiScale = 1.0, -- this can be fixed by changing the compatability settings for the .exe
    },
    showFPS = true,
    showColliders = false,
    deadzone = 0.15, -- controller deadzone
    useTransitions = false,

    audio = {
        fxVolume = 0.5,
        musicVolume = 0.5,
        ambienceVolume = 0.1
    },

    video = {
        width = 1600,
        height = 900,
    },

    ships = {
        accForce = 0.3,
    },

    bullets = {
        spreadAngle = 0.05, 
        spreadPower = 0.1, 
        speed = 15,
        maxAge = 60,
    },

    powerups = {
        amt = 20,
        maxAge = 1200, -- about 20 seconds at 60 fps
        
        healthIncrease = 4,
        machinegunTime = 300,
        machinegunReload = 30,
        turboForce = 0.3,

        mineAmt = 3,
        mineShockwaveRadius = 60,
        mineReload = 30,
        mineFuse = 300,
        mineDamage = 8,

        tornadoAge = 600,
        tornadoSteeringForce = 0.5,
        tornadoDamage = 0.015,

        aztecCoinDuration = 300,
    },

    bounds = {
        externalDim = 6000
    },

    game = {
        roundTime = 300
    }
}

function config.createWindow()
    love.window.setTitle(config.window.title)
    screens.setResolution(config.window.width, config.window.height)
end