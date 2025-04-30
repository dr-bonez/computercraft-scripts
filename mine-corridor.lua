local function getFuelValue(slot)
    local data = turtle.getItemDetail()
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

local function placeTorch()
    for slot = 1, 16 do
        if isTorch(slot) then
            turtle.select(slot)
            turtle.placeUp()
            turtle.select(1)
            return true
        end
    end
    return false
end

local function refuel(steps)
    for slot = 1, 16 do
        if turtle.getFuelLevel() > steps + 2 then
            break
        end
        local fuelValue = getFuelValue(slot)
        if fuelValue ~= 0 then
            if turtle.getFuelLevel() + fuelValue > turtle.getFuelLimit() then
                break
            end
            turtle.select(slot)
            turtle.refuel()
        end
    end
end

local function isInventoryFull()
    for slot = 1, 16 do
        if turtle.getItemCount(slot) == 0 then
            return false
        end
    end
    return true
end

local function returnToStart(steps)
    turtle.turnRight()
    turtle.turnRight()

    while steps > 0 do
        while turtle.detect() do
            turtle.dig()
        end
        if turtle.forward() then
            steps = steps - 1
        end
        if steps % 10 == 0 then
            placeTorch()
        end
    end

    turtle.turnRight()
    turtle.turnRight()
end

local function mineCorridor()
    local steps = 0

    while true do
        if turtle.getFuelLevel() <= steps + 2 then
            refuel(steps)
        end

        if isInventoryFull() then
            print("Inventory full")
            break
        end
        if turtle.getFuelLevel() <= steps then
            print("Low fuel")
            break
        end

        while turtle.detect() do
            turtle.dig()
        end

        if not turtle.forward() then
            print("Movement blocked, aborting")
            break
        end

        steps = steps + 1

        while turtle.detectUp() do
            local s, data = turtle.inspectUp()
            if s then
                if data["name"] ~= "minecraft:wall_torch" then
                    turtle.digUp()
                else
                    break
                end
            else
                break
            end
        end
    end

    if steps > 0 then
        print("Returning to start")
        returnToStart(steps)
    end
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

while not isInventoryFull() do
    print("Starting mining operation")
    mineCorridor()
    print("Operation complete")
    if not dumpInventory() then
        print("Failed to dump inventory")
    end
end
