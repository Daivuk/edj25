function angle_to_vector(angle)
    return math.cos(angle), math.sin(angle)
end

function wrap_angle(angle)
    return (angle + math.pi) % (2 * math.pi) - math.pi
end

function find_angle(vx, vy)
    return math.atan2(vy, vx)
end

function distance(p1x, p1y, p2x, p2y)
    local dx = p2x - p1x
    local dy = p2y - p1y
    return math.sqrt(dx * dx + dy * dy)
end

function distance_squared(p1x, p1y, p2x, p2y)
    local dx = p2x - p1x
    local dy = p2y - p1y
    return dx * dx + dy * dy
end

function rotate_angle(angle, desired_angle, dt)
    local diff = wrap_angle(desired_angle - angle)

    local max_step = dt * 5
    diff = math.max(-max_step, math.min(diff, max_step))

    angle = angle + diff
    return wrap_angle(angle)
end
