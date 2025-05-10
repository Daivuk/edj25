local WHALE_TEXTURE = love.graphics.newImage("textures/whale.png")
local whale_sound = love.audio.newSource("sounds/whale.wav", "static")
local whale = {}
local WHALE_SPEED = 50
local WHALE_TRAVEL_LENGTH = math.sqrt(2000 * 2000)
local WHALE_DURATION = WHALE_TRAVEL_LENGTH / WHALE_SPEED
local WHALE_SND_TRIGGER_TIME = WHALE_DURATION * 0.65

function reset_whale()
    whale = {
        x = 0,
        y = 0,
        angle = 0,
        active = false,
        timer = math.random(0, 20)
    }
end

function update_whale(dt)
    if not whale.active then
        whale.timer = whale.timer - dt
        if whale.timer <= 0 then
            whale.active = true
            whale.angle = math.random() * math.pi * 2
            local dir_x, dir_y = angle_to_vector(whale.angle)
            whale.x = math.random(-100, 100) - dir_x * WHALE_TRAVEL_LENGTH * 0.5
            whale.y = math.random(-100, 100) - dir_y * WHALE_TRAVEL_LENGTH * 0.5
            whale.timer = WHALE_DURATION
        end
    else
        local prev_time = whale.timer
        whale.timer = whale.timer - dt
        if prev_time > WHALE_SND_TRIGGER_TIME and whale.timer <= WHALE_SND_TRIGGER_TIME then
            whale_sound:play()
        end
        if whale.timer <= 0 then
            whale.active = false
            whale.timer = 10 + math.random(0, 20)
        else
            local dir_x, dir_y = angle_to_vector(whale.angle)
            whale.x = whale.x + dir_x * dt * WHALE_SPEED
            whale.y = whale.y + dir_y * dt * WHALE_SPEED
        end
    end
end

function draw_whale()
    if whale.active then
        love.graphics.setColor(1, 1, 1, 0.15)
        love.graphics.setBlendMode("alpha")
        love.graphics.draw(WHALE_TEXTURE, whale.x, whale.y, whale.angle, 1.5, 1.5)
    end
end
