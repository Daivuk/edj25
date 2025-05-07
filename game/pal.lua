local bit = require("bit")

function hexcolor(hex, a)
    a = a or 1
    local r = (bit.rshift(hex, 16) % 256) / 255
    local g = (bit.rshift(hex, 8) % 256) / 255
    local b = (hex % 256) / 255
    return {r, g, b, a}
end

SEA_COLOR = hexcolor(0x3f3f74)
CAUSTIC_COLOR = hexcolor(0x5b6ee1)
