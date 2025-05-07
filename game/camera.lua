function create_camera(x, y, zoom)
    return {
        x = x,
        y = y,
        zoom = zoom
    }
end

function update_camera(camera, dt)
    if love.keyboard.isScancodeDown("w") then
        camera.y = camera.y - dt * 64
    end
    if love.keyboard.isScancodeDown("d") then
        camera.x = camera.x + dt * 64
    end
    if love.keyboard.isScancodeDown("s") then
        camera.y = camera.y + dt * 64
    end
    if love.keyboard.isScancodeDown("a") then
        camera.x = camera.x - dt * 64
    end
end

function screen_to_world(camera, screen_x, screen_y)
    local w, h = love.graphics.getDimensions()
    local world_x = (screen_x - w * 0.5) / camera.zoom + camera.x
    local world_y = (screen_y - h * 0.5) / camera.zoom + camera.y
    return world_x, world_y
end

function push_camera(camera)
    local w, h = love.graphics.getDimensions()
    love.graphics.push()
    love.graphics.translate(w * 0.5, h * 0.5)
    love.graphics.scale(camera.zoom)
    love.graphics.translate(-camera.x, -camera.y)
end

function pop_camera(camera)
    love.graphics.pop()
end
