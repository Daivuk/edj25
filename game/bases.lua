local BASE_TEXTURE = love.graphics.newImage("textures/bases.png")
BASE_TEXTURE:setFilter("nearest", "nearest")
local src_w = BASE_TEXTURE:getWidth()
local src_h = BASE_TEXTURE:getHeight()
local BASE_DEFS = {
    {
        quads = {
            build1 = love.graphics.newQuad(8 + 48 * 0, 8, 48, 64, src_w, src_h),
            build2 = love.graphics.newQuad(8 + 48 * 1, 8, 48, 64, src_w, src_h),
            floor = love.graphics.newQuad(8 + 48 * 3, 8, 48, 64, src_w, src_h),
            interior_walls = love.graphics.newQuad(8 + 48 * 4, 8, 48, 64, src_w, src_h),
            exterior = love.graphics.newQuad(8 + 48 * 2, 8, 48, 64, src_w, src_h),
            ox = 24,
            oy = 32
        }
    },
    {
        quads = {
            build1 = love.graphics.newQuad(16 + 80 * 0, 80, 64, 64, src_w, src_h),
            build2 = love.graphics.newQuad(16 + 80 * 1, 80, 64, 64, src_w, src_h),
            floor = love.graphics.newQuad(16 + 80 * 4, 80, 64, 64, src_w, src_h),
            interior_walls = love.graphics.newQuad(16 + 80 * 5, 80, 64, 64, src_w, src_h),
            exterior = love.graphics.newQuad(16 + 80 * 2, 80, 64, 64, src_w, src_h),
            exterior_windows = love.graphics.newQuad(16 + 80 * 3, 80, 64, 64, src_w, src_h),
            ox = 32,
            oy = 32
        }
    }
}

bases = {}
hide_exteriors = false

function reset_bases()
    bases = {
        {
            def = BASE_DEFS[2],
            x = 0,
            y = 0
        }
    }
end

function update_bases(dt)
end

function draw_bases_floor()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha")
    for _, base in ipairs(bases) do
        love.graphics.draw(BASE_TEXTURE, base.def.quads.floor, base.x, base.y, 0, 1, 1, base.def.quads.ox, base.def.quads.oy)
    end
end

function draw_bases_walls()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha")
    love.graphics.setShader(base_caustic_shader)
    for _, base in ipairs(bases) do
        if hide_exteriors then
            love.graphics.draw(BASE_TEXTURE, base.def.quads.interior_walls, base.x, base.y, 0, 1, 1, base.def.quads.ox, base.def.quads.oy)
        else
            love.graphics.draw(BASE_TEXTURE, base.def.quads.exterior, base.x, base.y, 0, 1, 1, base.def.quads.ox, base.def.quads.oy)
        end
    end
    love.graphics.setShader()
end
