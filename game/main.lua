require("utils")
require("map")
require("camera")
require("pal")
require("fishes")
require("whale")

mouse_x = 0
mouse_y = 0

function love.load()
    love.window.setMode(1280, 720, {
        resizable = true
    })
    love.window.maximize()

    new_game()
end

function new_game()
    reset_map()
    reset_fishes()
    reset_whale()
    camera = create_camera(0, 0, 3)
    game_state = "game"
end

function love.update(dt)
    if game_state == "main_menu" then
    elseif game_state == "game" then
        update_map(dt)
        update_camera(camera, dt)
        mouse_x, mouse_y = screen_to_world(camera, love.mouse.getPosition())
        update_fishes(dt)
        update_whale(dt)
    elseif game_state == "ingame_menu" then
    end
end

function love.draw()
    if game_state == "main_menu" then
    elseif game_state == "game" then
        push_camera(camera)
        draw_map()
        pop_camera()
    elseif game_state == "ingame_menu" then
    end
end

function love.wheelmoved(x, y)
    if y < 0 then
        -- Mouse wheel scrolled down
        camera.zoom = camera.zoom / 2
    elseif y > 0 then
        -- Mouse wheel scrolled up
        camera.zoom = camera.zoom * 2
    end
end
