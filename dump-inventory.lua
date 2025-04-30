local function getFuelValue(slot)
    local data = turtle.getItemDetail(slot)
    if data ~= nil then
        if data["name"] == "minecraft:coal" then
            return 80
        elseif data["name"] == "minecraft:lava_bucket" then
            return 1000
        end
    end
    return 0
end

local function isTorch(slot)
    local data = turtle.getItemDetail(slot)
    return data ~= nil and data["name"] == "minecraft:torch"
end

local function dumpInventory()
    local s, data = turtle.inspectUp()
    if not s then
        return false
    end
    if not data["tags"]["c:chests"] then
        return false
    end
    for slot = 1, 16 do
        if getFuelValue(slot) == 0 and not isTorch(slot) then
            turtle.select(slot)
            if not turtle.dropUp() then
                return false
            end
        end
    end
    return true
end

if not dumpInventory() then
    print("Failed to dump inventory")
end
