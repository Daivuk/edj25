local caustic_shader = love.graphics.newShader("shaders/caustic.frag")
local caustic_anim = 0
local caustic_mesh = nil
undetwater_snd = love.audio.newSource("sounds/underwater.flac", "static")

function reset_map()
    caustic_anim = 0;

    local vertices = {
        {-1024, -1024, 0, 0},
        {1024, -1024, 8, 0},
        {1024, 1024, 8, 8},
        {-1024, 1024, 0, 8},
    }
    caustic_mesh = love.graphics.newMesh(vertices, "fan", "static")
    local caustic_texture = love.graphics.newImage("textures/caustic.png")
    caustic_texture:setWrap("repeat", "repeat")
    caustic_mesh:setTexture(caustic_texture)

    undetwater_snd:setLooping(true)
    undetwater_snd:setPitch(0.75)
    undetwater_snd:setVolume(0.5)
    undetwater_snd:play()
end

function update_map(dt)
    caustic_anim  = caustic_anim + dt * 0.3
    caustic_shader:send("anim", caustic_anim)
end

function draw_caustic()

    love.graphics.setBlendMode("add")
    love.graphics.setShader(caustic_shader)

    local caustic_strength = 0.03
    love.graphics.setColor(CAUSTIC_COLOR[1], CAUSTIC_COLOR[2], CAUSTIC_COLOR[3], CAUSTIC_COLOR[4] * caustic_strength)
    love.graphics.draw(caustic_mesh, 0, 0)

    love.graphics.push()
    local a = 1
    for i = 1, 4 do
        love.graphics.scale(1.01)
        love.graphics.translate(-camera.x * 0.01, -camera.y * 0.01 - 1) -- Why does 0.01 works here for parallax? Fix that
        love.graphics.setColor(CAUSTIC_COLOR[1], CAUSTIC_COLOR[2], CAUSTIC_COLOR[3], CAUSTIC_COLOR[4] * caustic_strength * a)
        love.graphics.draw(caustic_mesh, 0, 0)
        a = a / 1.3
    end

    love.graphics.pop()
    love.graphics.setShader()
end

function draw_map()
    love.graphics.clear(SEA_COLOR)
    draw_caustic()
    draw_whale()
    draw_fishes()
end
