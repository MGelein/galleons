local function audioClip(url)
    return love.audio.newSource('assets/audio/' .. url .. '.wav', 'static')
end

local function audioStream(url)
    return love.audio.newSource('assets/audio/' .. url .. '.ogg', 'stream')
end

sounds = {
    shoot1 = audioClip('shot1'),
    shoot2 = audioClip('shot2'),
    shoot3 = audioClip('shot3'),
    shoot4 = audioClip('shot4'),

    splash1 = audioClip("splash1"),
    splash2 = audioClip("splash2"),
    splash3 = audioClip("splash3"),
    splash4 = audioClip("splash4"),
    splash5 = audioClip("splash5"),
    splash6 = audioClip("splash6"),

    wood_breaking1 = audioClip("wood_breaking1"),
    wood_breaking2 = audioClip("wood_breaking2"),
    wood_breaking3 = audioClip("wood_breaking3"),
    wood_breaking4 = audioClip("wood_breaking4"),
    wood_breaking5 = audioClip("wood_breaking5"),
    wood_breaking6 = audioClip("wood_breaking6"),

    impact1 = audioClip("impact1"),
    impact2 = audioClip("impact2"),
    impact3 = audioClip("impact3"),
    impact4 = audioClip("impact4"),
    impact5 = audioClip("impact5"),

    impact_sand1 = audioClip("impact_sand1"),
    impact_sand2 = audioClip("impact_sand2"),
    impact_sand3 = audioClip("impact_sand3"),
    impact_sand4 = audioClip("impact_sand4"),

    gust = audioClip('gust'),
    repair = audioClip('repair'),
    ghost = audioClip('ghost'),
    cannonsReady = audioClip('cannonsReady'),
    explosion = audioClip('explosion'),
    transition = audioClip('transitionwave'),
    tornado = audioClip('tornado'),

    bgm = audioStream('music'),
    sea = audioStream('waves'),
}

local function stopAndPlay(source)
    source:stop()
    source:setVolume(config.audio.fxVolume * config.audio.fxMult)
    source:play()
end
sounds.stopAndPlay = stopAndPlay

function sounds.updateVolumes()
    sounds.bgm:setVolume(config.audio.musicVolume * config.audio.musicMult)
    sounds.sea:setVolume(config.audio.ambienceVolume * config.audio.ambienceMult)
end

function sounds.shoot()
   local shotIndex = math.floor(love.math.random() * 4) + 1
   if shotIndex == 1 then stopAndPlay(sounds.shoot1)
   elseif shotIndex == 2 then stopAndPlay(sounds.shoot2)
   elseif shotIndex == 3 then stopAndPlay(sounds.shoot3)
   else stopAndPlay(sounds.shoot4) end
end

function sounds.splash()
   local splashIndex = math.floor(love.math.random() * 6) + 1
   if splashIndex == 1 then stopAndPlay(sounds.splash1)
   elseif splashIndex == 2 then stopAndPlay(sounds.splash2)
   elseif splashIndex == 3 then stopAndPlay(sounds.splash3)
   elseif splashIndex == 4 then stopAndPlay(sounds.splash4)
   elseif splashIndex == 5 then stopAndPlay(sounds.splash5)
   else stopAndPlay(sounds.splash6) end
end

function sounds.impact()
    local impactIndex = math.floor(love.math.random() * 5) + 1
    if impactIndex == 1 then stopAndPlay(sounds.impact1)
    elseif impactIndex == 2 then stopAndPlay(sounds.impact2)
    elseif impactIndex == 3 then stopAndPlay(sounds.impact3)
    elseif impactIndex == 4 then stopAndPlay(sounds.impact4)
    else stopAndPlay(sounds.impact5) end
 end

 
function sounds.impactSand()
    local impactSandIndex = math.floor(love.math.random() * 4) + 1
    if impactSandIndex == 1 then stopAndPlay(sounds.impact_sand1)
    elseif impactSandIndex == 2 then stopAndPlay(sounds.impact_sand2)
    elseif impactSandIndex == 3 then stopAndPlay(sounds.impact_sand3)
    else stopAndPlay(sounds.impact_sand4) end
end

function sounds.woodBreak()
    local woodBreakingIndex = math.floor(love.math.random() * 6) + 1
    if woodBreakingIndex == 1 then stopAndPlay(sounds.wood_breaking1)
    elseif woodBreakingIndex == 2 then stopAndPlay(sounds.wood_breaking2)
    elseif woodBreakingIndex == 3 then stopAndPlay(sounds.wood_breaking3)
    elseif woodBreakingIndex == 4 then stopAndPlay(sounds.wood_breaking4)
    elseif woodBreakingIndex == 5 then stopAndPlay(sounds.wood_breaking5)
    else stopAndPlay(sounds.wood_breaking6) end
 end

function sounds.playBGM()
    sounds.bgm:setVolume(config.audio.musicVolume * config.audio.musicMult)
    sounds.bgm:play()
end

function sounds.stopBGM()
    sounds.bgm:stop()
end

function sounds.playAmbience()
    sounds.sea:setVolume(config.audio.ambienceVolume * config.audio.ambienceMult)
    sounds.sea:play()
end

function sounds.stopAmbience()
    sounds.sea:stop()
end

function sounds.playTransition()
    sounds.transition:stop()
    sounds.transition:setVolume(config.audio.fxVolume * config.audio.fxMult)
    sounds.transition:play()
end