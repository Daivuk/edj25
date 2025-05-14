local BASE_TEXTURE = love.graphics.newImage("textures/bases.png")
BASE_TEXTURE:setFilter("nearest", "nearest")
local src_w = BASE_TEXTURE:getWidth()
local src_h = BASE_TEXTURE:getHeight()
local toggle_interior_snd = love.audio.newSource("sounds/toggle_interiors.wav", "static")
local BASE_DEFS = {
    {
        name = "Conduit",
        quads = {
            build1 = love.graphics.newQuad(8 + 48 * 0, 8, 48, 64, src_w, src_h),
            build2 = love.graphics.newQuad(8 + 48 * 1, 8, 48, 64, src_w, src_h),
            floor = love.graphics.newQuad(8 + 48 * 3, 8, 48, 64, src_w, src_h),
            interior_walls = love.graphics.newQuad(8 + 48 * 4, 8, 48, 64, src_w, src_h),
            exterior = love.graphics.newQuad(8 + 48 * 2, 8, 48, 64, src_w, src_h),
            ox = 24,
            oy = 32
        },
        connectors = {
            {
                x = 24,
                y = 8,
                angle = math.pi / 2
            },
            {
                x = 24,
                y = 40,
                angle = math.pi * 2 * 3 / 4
            }
        }
    },
    {
        name = "Room",
        quads = {
            build1 = love.graphics.newQuad(16 + 80 * 0, 80, 64, 64, src_w, src_h),
            build2 = love.graphics.newQuad(16 + 80 * 1, 80, 64, 64, src_w, src_h),
            floor = love.graphics.newQuad(16 + 80 * 3, 80, 64, 64, src_w, src_h),
            interior_walls = love.graphics.newQuad(16 + 80 * 4, 80, 64, 64, src_w, src_h),
            exterior = love.graphics.newQuad(16 + 80 * 2, 80, 64, 64, src_w, src_h),
            ox = 32,
            oy = 32
        },
        connectors = {
            {
                x = 64,
                y = 32,
                angle = 0
            },
            {
                x = 32,
                y = 64,
                angle = math.pi / 2
            },
            {
                x = 0,
                y = 32,
                angle = math.pi
            },
            {
                x = 32,
                y = 0,
                angle = math.pi * 2 * 3 / 4
            }
        }
    },
    {
        name = "SAS",
        quads = {
            build1 = love.graphics.newQuad(8 + 48 * 5, 8, 48, 48, src_w, src_h),
            build2 = love.graphics.newQuad(8 + 48 * 6, 8, 48, 48, src_w, src_h),
            floor = love.graphics.newQuad(8 + 48 * 8, 8, 48, 48, src_w, src_h),
            interior_walls = love.graphics.newQuad(8 + 48 * 9, 8, 48, 48, src_w, src_h),
            exterior = love.graphics.newQuad(8 + 48 * 7, 8, 48, 48, src_w, src_h),
            ox = 24,
            oy = 22
        },
        connectors = {
            {
                x = 24,
                y = 36,
                angle = math.pi / 2
            }
        }
    }
}
local exterior_alpha = 1

bases = {}
hide_exteriors = false

function toggle_interiors()
    hide_exteriors = not hide_exteriors
    toggle_interior_snd:setVolume(0.5)
    toggle_interior_snd:setPitch(0.85)
    toggle_interior_snd:play()
end

function reset_bases()
    bases = {
        {
            def = BASE_DEFS[2],
            x = 0,
            y = 0,
            angle = 0,
            available_connectors = {1, 2, 3}
        },
        {
            def = BASE_DEFS[3],
            x = 0,
            y = -45,
            angle = 0,
            available_connectors = {}
        }
    }
end

function update_bases(dt)
    if hide_exteriors then
        exterior_alpha = math.max(0, exterior_alpha - dt * 4)
    else
        exterior_alpha = math.min(1, exterior_alpha + dt * 4)
    end
end

function draw_bases_floor()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha")
    for _, base in ipairs(bases) do
        love.graphics.draw(BASE_TEXTURE, base.def.quads.floor, base.x, base.y, 0, 1, 1, base.def.quads.ox, base.def.quads.oy)
    end
end

function draw_bases_walls()
    love.graphics.setBlendMode("alpha")
    love.graphics.setShader(base_caustic_shader)
    for _, base in ipairs(bases) do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(BASE_TEXTURE, base.def.quads.interior_walls, base.x, base.y, 0, 1, 1, base.def.quads.ox, base.def.quads.oy)
        love.graphics.setColor(1, 1, 1, exterior_alpha)
        love.graphics.draw(BASE_TEXTURE, base.def.quads.exterior, base.x, base.y, 0, 1, 1, base.def.quads.ox, base.def.quads.oy)
    end
    love.graphics.setShader()
end
