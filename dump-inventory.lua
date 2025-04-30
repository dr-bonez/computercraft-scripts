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
    if not s or not data["tags"]["c:chests"] then
        return false
    end
    s, data = turtle.inspectDown()
    if not s or not data["tags"]["c:chests"] then
        return false
    end
    local fuelStacks = 0
    local torchStacks = 0
    for slot = 1, 16 do
        if turtle.getItemCount(slot) > 0 then
            local target = 'up'
            if getFuelValue(slot) ~= 0 then
                if fuelStacks < 2 then
                    fuelStacks = fuelStacks + 1
                    goto continue
                end
                target = 'down'
            elseif isTorch(slot) then
                if torchStacks < 2 then
                    torchStacks = torchStacks + 1
                    goto continue
                end
                target = 'down'
            end
            turtle.select(slot)
            local res = false
            if target == 'up' then
                res = turtle.dropUp()
            elseif target == 'down' then
                res = turtle.dropDown()
            end
            if not res then
                return false
            end
        end
        ::continue::
    end
    return true
end

if not dumpInventory() then
    print("Failed to dump inventory")
end
