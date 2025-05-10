local caustic_shader = love.graphics.newShader("shaders/caustic.frag")
base_caustic_shader = love.graphics.newShader("shaders/base_caustic.frag")
caustic_anim = 0
local caustic_mesh = nil
undetwater_snd = love.audio.newSource("sounds/underwater.flac", "static")
local caustic_texture = love.graphics.newImage("textures/caustic.png")

function reset_map()
    caustic_anim = 0;

    local vertices = {
        {-1024, -1024, 0, 0},
        {1024, -1024, 8, 0},
        {1024, 1024, 8, 8},
        {-1024, 1024, 0, 8},
    }
    caustic_mesh = love.graphics.newMesh(vertices, "fan", "static")
    caustic_texture:setWrap("repeat", "repeat")
    caustic_mesh:setTexture(caustic_texture)

    undetwater_snd:setLooping(true)
    undetwater_snd:setPitch(0.75)
    undetwater_snd:setVolume(0.5)
    undetwater_snd:play()
end

function update_map(dt)
    local w, h = love.graphics.getDimensions()

    caustic_anim  = caustic_anim + dt * 0.3
    caustic_shader:send("anim", caustic_anim)
    caustic_shader:send("camera_zoom", camera.zoom)
    caustic_shader:send("camera_pos", {camera.x, camera.y})
    caustic_shader:send("res", {w, h})

    base_caustic_shader:send("anim", caustic_anim * 2)
    base_caustic_shader:send("caustic_tex", caustic_texture)
    base_caustic_shader:send("camera_zoom", camera.zoom)
    base_caustic_shader:send("camera_pos", {camera.x, camera.y})
    base_caustic_shader:send("res", {w, h})
end

function draw_caustic()
    love.graphics.setBlendMode("add")
    love.graphics.setShader(caustic_shader)

    love.graphics.setColor(CAUSTIC_COLOR[1], CAUSTIC_COLOR[2], CAUSTIC_COLOR[3], CAUSTIC_COLOR[4])
    love.graphics.draw(caustic_mesh, 0, 0)
    love.graphics.setShader()
end

function draw_map()
    love.graphics.clear(SEA_COLOR)
    draw_caustic()
    draw_whale()
    draw_fishes()
    draw_bases_floor()
    draw_bases_walls()
end
