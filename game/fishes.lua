local fishes = {} -- I know that plurial of fish is fish... but for coding purpose, I need to know if its an array of fish or not...

local fish_sprite_sheet = love.graphics.newImage("textures/fishes.png")
fish_sprite_sheet:setFilter("nearest", "nearest")

local FISH_FRAMES = {
    love.graphics.newQuad(0, 0, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(16, 0, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(32, 0, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(48, 0, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(0, 16, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(16, 16, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(32, 16, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(48, 16, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(0, 32, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(16, 32, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(32, 32, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight()),
    love.graphics.newQuad(48, 32, 16, 16, fish_sprite_sheet:getWidth(), fish_sprite_sheet:getHeight())
}

-- Fish pattern animations.
-- Instead of going full random, we predefine patterns that they can use. Each array are "timers" between swims.
-- Each stroke, the fish has a chance to change direction.
local FISH_SWIM_PATTERNS = {
    {2}, -- Swim once then waits 1 sec
    {0.2, 0.2, 1}, -- swims 3 shot fast, then waits a bit
    {0.2, 0.2, 0.5}, -- swims 3 shot fast, resume fast
    {0.1, 0.1, 0.5, 1.5}, -- Fast swim then slower, then waits
    {0.1, 1.5}, -- Fast swim then waits
    {0.1}, -- Quick very fast swim
}

function reset_fishes()
    fishes = {}
    for i = 1, 100 do
        create_random_fish(nil)
    end
end

local function fish_swim(fish)
    fish.swim_pattern_t = 0
    fish.anim_speed = math.min(FISH_SWIM_PATTERNS[fish.swim_pattern][fish.swim_pattern_frame], 0.75)
    fish.swim_frame = 0
    fish.speed = math.min(fish.speed + 1, 2)
end

local function change_fish_swim_pattern(fish)
    -- If we have a teacher, and we go too far from it, lets turn toward it
    if fish.teacher then
        local dist_squared = distance_squared(fish.x, fish.y, fish.teacher.x, fish.teacher.y)
        if dist_squared > 32 * 32 then
            local angle_to_teacher = find_angle(fish.teacher.x - fish.x, fish.teacher.y - fish.y)
            fish.desired_angle = angle_to_teacher + math.random() * math.pi / 2 - math.pi / 4
            fish.swim_pattern = 3
            fish.swim_pattern_frame = 1
            fish_swim(fish)
            return
        end
    end

    fish.swim_pattern = math.random(#FISH_SWIM_PATTERNS)
    fish.swim_pattern_frame = 1
    fish_swim(fish)

    -- change angle. always avoid going out of bounds. Otherwise, change randomly
    if fish.y < -800 then
        fish.desired_angle = math.random() * math.pi / 2 - math.pi / 4 + math.pi / 2
    elseif fish.x > 800 then
        fish.desired_angle = math.random() * math.pi / 2 - math.pi / 4 + math.pi
    elseif fish.y > 800 then
        fish.desired_angle = math.random() * math.pi / 2 - math.pi / 4 - math.pi / 2
    elseif fish.x < -800 then
        fish.desired_angle = math.random() * math.pi / 2 - math.pi / 4
    elseif math.random() < 0.5 then
        fish.desired_angle = fish.desired_angle + math.random() * math.pi - math.pi / 2
    end
end

function create_random_fish(teacher)
    local angle = math.random() * math.pi * 2
    local fish = {
        x = math.random(-800, 800),
        y = math.random(-800, 800),
        teacher = teacher,
        type = math.random(0, 2),
        angle = angle,
        desired_angle = angle,
        speed = 0,
        swim_pattern = 0, -- Current swim pattern
        swim_pattern_frame = 1, -- Current keyframe in swim pattern
        swim_pattern_t = 0, -- Current time in current keyframe in swim pattern
        swim_frame = 0, -- Current swim frame [0, 3]
        swim_anim_speed = 0, -- Swim frame animation speed
    }
    if teacher then
        fish.type = teacher.type
    end
    change_fish_swim_pattern(fish)
    table.insert(fishes, fish)
    local is_school = math.random() > 0.5
    if is_school and not teacher then
        local count = math.random(1, 4)
        for i = 1, count do
            local student = create_random_fish(fish)
            student.angle = fish.angle
            student.x = fish.x + math.random(-32, 32)
            student.y = fish.y + math.random(-32, 32)
        end
    end
    return fish
end

function update_fishes(dt)
    for _, fish in ipairs(fishes) do
        -- Handle swim pattern
        fish.swim_pattern_t = fish.swim_pattern_t + dt
        local swim_pattern = FISH_SWIM_PATTERNS[fish.swim_pattern]
        local swim_pattern_duration = swim_pattern[fish.swim_pattern_frame]
        if fish.swim_pattern_t >= swim_pattern_duration then
            fish.swim_pattern_frame = fish.swim_pattern_frame + 1
            if fish.swim_pattern_frame > #swim_pattern then
                change_fish_swim_pattern(fish)
            else
                fish_swim(fish)
            end
        end

        -- Swim animation
        fish.swim_frame = fish.swim_frame + dt / fish.anim_speed * 4
        if math.floor(fish.swim_frame) > 3 then
           fish.swim_frame = 4
        end

        -- Movement
        fish.speed = math.max(0, fish.speed - dt)
        local mx, my = angle_to_vector(fish.angle)
        local FISH_SPEED = 15
        fish.x = fish.x + mx * dt * FISH_SPEED * fish.speed
        fish.y = fish.y + my * dt * FISH_SPEED * fish.speed

        -- Rotate
        fish.angle = rotate_angle(fish.angle, fish.desired_angle, dt * 3)
    end
end

function draw_fishes()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha")
    -- love.graphics.line(-800, -800, 800, -800)
    -- love.graphics.line(800, -800, 800, 800)
    -- love.graphics.line(800, 800, -800, 800)
    -- love.graphics.line(-800, 800, -800, -800)
    for _, fish in ipairs(fishes) do
        local quad = FISH_FRAMES[fish.type * 4 + math.floor(fish.swim_frame) % 4 + 1]
        -- if fish.teacher then
        --     love.graphics.line(fish.x, fish.y, fish.teacher.x, fish.teacher.y)
        -- end
        love.graphics.draw(fish_sprite_sheet, quad, fish.x, fish.y, fish.angle, 1, 1, 8, 8)
    end
end
