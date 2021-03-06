config = {
    window = {
        width = 1280,
        height = 720,
        title = 'Galleons',
        fullscreen = false, -- if fullscreen is set, the window size becomes useless
        dpiScale = 1.0, -- this can be fixed by changing the compatability settings for the .exe
    },
    showFPS = false,
    showColliders = false,
    deadzone = 0.15, -- controller deadzone
    useTransitions = true,
    fullFontOutlining = false,
    useGameCountdown = true,

    ui = {
        moveTimeout = 10,
        col = {r = 0.65, g = 0.4, b = 0.2, a = 1},
        shd = {r = 0.2, g = 0.2, b = 0.2, a = 1}
    },

    audio = {
        fxVolume = 0.5,
        musicVolume = 0.5,
        ambienceVolume = 0.1,
        fxMult = 0.9,
        musicMult = 0.9,
        ambienceMult = 0.9,
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
        damage = 1.5,
        fireFrames = 20,
    },

    powerups = {
        amt = 20,
        maxAge = 1200, -- about 20 seconds at 60 fps

        turboChance = 30,
        mineChance = 25,
        healthChance = 20,
        machinegunChance = 10,
        aztecCoinChance = 10,
        tornadoChance = 5,
        
        healthIncrease = 4,
        machinegunTime = 300,
        machinegunReload = 30,
        turboForce = 0.3,

        mineAmt = 3,
        mineShockwaveRadius = 60,
        mineReload = 30,
        mineFuse = 3600,
        mineDamage = 8,

        tornadoAge = 600,
        tornadoSteeringForce = 0.5,
        tornadoDamage = 0.015,

        aztecCoinDuration = 300,
    },

    bounds = {
        internalDim = 4000
    },

    game = {
        kothTime = 60,
        matchTime = 300,
        ctfTime = 600
    }
}

function config.createWindow()
    love.mouse.setVisible(false)
    love.window.setTitle(config.window.title)
    screens.setResolution(config.window.width, config.window.height)
end