-- ============================================================================
-- Weapon Orbit System
-- Description: Visual enhancement module that makes unequipped back weapons
--              orbit around the player character in a circular pattern.
-- Features:    - Circular orbit animation for back weapons
--              - Wobble / floating effect (X/Z axis offset)
--              - Self-rotation of each weapon
--              - Dynamic radius and speed configuration
--              - Automatic attach/detach management
-- Purpose:     Detaches all back weapons (not currently held) from the player
--              and makes them fly around the player in a circular orbit with
--              wobble floating and self-rotation effects. When stopped, weapons
--              are automatically re-attached to the player and restored to their
--              original position/rotation. Pure visual effect module.
-- Price:       FREE - This code is provided at no cost. If you paid for it,
--              you were scammed. Please join the official community for updates.
-- ============================================================================

local WeaponOrbit = {}

local CONFIG = {
    ORBIT_RADIUS = 150,
    ORBIT_SPEED = 180,
    ORBIT_INTERVAL = 0.016,
    ORBIT_ENABLED = true,
    WOBBLE_AMPLITUDE = 30,
    WOBBLE_SPEED = 3,
    SELF_ROTATION_SPEED = 360,
}

local currentOrbitTimer = nil
local currentTime = 0
local weapons = {}
local weaponData = {}
local originalTransforms = {}

-- Check if a slua object is valid
local function Valid(obj)
    return slua.isValid(obj)
end

-- Get the local player character
local function GetLocalPlayer()
    local GameplayData = require("GameLua.GameCore.Data.GameplayData")
    return GameplayData.GetPlayerCharacter()
end

-- Get the currently equipped weapon slot index
local function GetCurrentWeaponSlot()
    local character = GetLocalPlayer()
    if not Valid(character) then
        return nil
    end
    local weaponManager = character:GetWeaponManager()
    if not Valid(weaponManager) then
        return nil
    end
    return weaponManager:GetCurrentUsingPropSlot()
end

-- Retrieve all weapons currently on the player's back (not held)
local function GetAllBackWeapons()
    local weaponList = {}
    local character = GetLocalPlayer()
    if not Valid(character) then
        return weaponList
    end
    local weaponManager = character:GetWeaponManager()
    if not Valid(weaponManager) then
        return weaponList
    end
    local currentSlot = GetCurrentWeaponSlot()
    for slot = 0, 10 do
        local weapon = weaponManager:GetInventoryWeaponByPropSlot(slot)
        if Valid(weapon) and slot ~= currentSlot then
            table.insert(weaponList, weapon)
        end
    end
    return weaponList
end

-- Initialize orbit data for each weapon (angle, self-rotation, wobble phase, radius offset)
local function InitWeaponData()
    for i, weapon in ipairs(weapons) do
        if Valid(weapon) and not weaponData[weapon] then
            weaponData[weapon] = {
                orbitAngle = (360 / #weapons) * (i - 1),
                selfAngle = math.random(0, 360),
                wobblePhase = math.random(0, 360),
                radiusOffset = (math.random(-20, 20)),
            }
        end
    end
end

-- Detach weapons from the player and save original transform/parent info
local function DetachWeapons()
    local EAttachmentRule = import("EAttachmentRule")
    for _, weapon in ipairs(weapons) do
        if Valid(weapon) then
            local key = tostring(weapon)
            if not originalTransforms[key] then
                originalTransforms[key] = {
                    location = weapon:K2_GetActorLocation(),
                    rotation = weapon:K2_GetActorRotation(),
                    parent = weapon:GetAttachParentActor(),
                }
            end
            weapon:K2_DetachFromActor(EAttachmentRule.KeepWorld, EAttachmentRule.KeepWorld, EAttachmentRule.KeepWorld)
        end
    end
end

-- Re-attach weapons to the player and restore their original transform
local function AttachWeaponsBack()
    local EAttachmentRule = import("EAttachmentRule")
    for _, weapon in ipairs(weapons) do
        local key = tostring(weapon)
        local trans = originalTransforms[key]
        if trans and trans.parent and Valid(trans.parent) then
            weapon:K2_AttachToActor(trans.parent, "None", EAttachmentRule.SnapToTarget, EAttachmentRule.SnapToTarget, EAttachmentRule.SnapToTarget, false)
            weapon:K2_SetActorLocation(trans.location, false, nil, false)
            weapon:K2_SetActorRotation(trans.rotation, false)
        end
    end
    originalTransforms = {}
end

-- Per-frame update: compute circular orbit + wobble + self-rotation and apply to weapons
local function OrbitUpdate()
    if not CONFIG.ORBIT_ENABLED then
        return
    end
    local character = GetLocalPlayer()
    if not Valid(character) then
        return
    end
    weapons = GetAllBackWeapons()
    if #weapons == 0 then
        return
    end
    InitWeaponData()
    local centerLoc = character:K2_GetActorLocation()
    currentTime = currentTime + CONFIG.ORBIT_INTERVAL
    for _, weapon in ipairs(weapons) do
        if Valid(weapon) and weaponData[weapon] then
            local data = weaponData[weapon]
            local orbitRad = math.rad(data.orbitAngle + currentTime * CONFIG.ORBIT_SPEED)
            local radius = CONFIG.ORBIT_RADIUS + data.radiusOffset
            local wobbleX = math.sin(currentTime * CONFIG.WOBBLE_SPEED + math.rad(data.wobblePhase)) * CONFIG.WOBBLE_AMPLITUDE
            local wobbleZ = math.cos(currentTime * CONFIG.WOBBLE_SPEED * 1.3 + math.rad(data.wobblePhase)) * CONFIG.WOBBLE_AMPLITUDE
            local offsetX = radius * math.cos(orbitRad) + wobbleX
            local offsetY = radius * math.sin(orbitRad)
            local offsetZ = 50 + wobbleZ
            local newLoc = FVector(centerLoc.X + offsetX, centerLoc.Y + offsetY, centerLoc.Z + offsetZ)
            weapon:K2_SetActorLocation(newLoc, false, nil, false)
            data.selfAngle = data.selfAngle + CONFIG.SELF_ROTATION_SPEED * CONFIG.ORBIT_INTERVAL
            if data.selfAngle >= 360 then
                data.selfAngle = data.selfAngle - 360
            end
            local selfRot = FRotator(0, data.selfAngle, math.sin(currentTime * CONFIG.WOBBLE_SPEED * 2) * 15)
            weapon:K2_SetActorRotation(selfRot, false)
        end
    end
end

-- Start the orbit system: fetch back weapons, init data, detach, and create timer
local function StartOrbit()
    if currentOrbitTimer then
        return
    end
    weapons = GetAllBackWeapons()
    if #weapons == 0 then
        return
    end
    weaponData = {}
    InitWeaponData()
    DetachWeapons()
    currentTime = 0
    local character = GetLocalPlayer()
    if not Valid(character) then
        return
    end
    currentOrbitTimer = character:AddGameTimer(CONFIG.ORBIT_INTERVAL, true, OrbitUpdate)
end

-- Stop the orbit system: remove timer and re-attach weapons to player
local function StopOrbit()
    if currentOrbitTimer then
        local character = GetLocalPlayer()
        if Valid(character) then
            character:RemoveGameTimer(currentOrbitTimer)
        end
        currentOrbitTimer = nil
    end
    AttachWeaponsBack()
    weaponData = {}
end

-- Main entry point: start the orbit system
local function Main()
    StartOrbit()
    return true
end

return Main()
