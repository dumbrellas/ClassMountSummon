-- Register the /cmount command
SLASH_CMOUNT1 = "/cmount"
SlashCmdList["CMOUNT"] = function()
    SummonClassMount()
end

-- Table of class hall mounts using spell IDs
local classMountSpellIDs = {
    ["DEATHKNIGHT"] = { 229387 }, -- Deathlord's Vilebrood Vanquisher
    ["DEMONHUNTER"] = { 229417 }, -- Slayer's Felbroken Shrieker
    ["HUNTER"] = { 229386, 229438, 229439 }, -- Huntmaster's Loyal Wolfhawk (multiple)
    ["MAGE"] = { 229376 }, -- Archmage's Prismatic Disc
    ["MONK"] = { 229385 }, -- Ban-Lu, Grandmaster's Companion
    ["PALADIN"] = { 231435, 231589, 231587, 231588 }, -- Highlord's Golden Charger (multiple)
    ["PRIEST"] = { 229377 }, -- High Priest's Lightsworn Seeker
    ["ROGUE"] = { 231434, 231523, 231524, 231525 }, -- Shadowblade's Murderous Omen (multiple)
    ["SHAMAN"] = { 231442 }, -- Farseer's Raging Tempest
    ["WARLOCK"] = { 232412, 238452, 238454 }, -- Netherlord's Chaotic Wrathsteed (multiple)
    ["WARRIOR"] = { 229388 } -- Battlelord's Bloodthirsty War Wyrm
}

-- Function to get the class name with class color
local function GetClassColoredName()
    local className, classFile, _ = UnitClass("player")
    local color = RAID_CLASS_COLORS[classFile]
    if color then
        return string.format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, className)
    else
        return className
    end
end

-- Function to find and aggregate known mounts from a list of spell IDs
local function GetKnownMountIDsFromSpellIDs(spellIDs)
    local mountIDs = C_MountJournal.GetMountIDs()
    local knownMounts = {}

    for _, mountID in ipairs(mountIDs) do
        local name, currentSpellID, icon, isActive, isUsable, sourceType, isFavorite, isFactionSpecific, faction, shouldHideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID)
        if isCollected and isUsable then
            for _, spellID in ipairs(spellIDs) do
                if currentSpellID == spellID then
                    table.insert(knownMounts, mountID) -- Add to known mounts if collected
                end
            end
        end
    end

    return knownMounts
end

-- Function to summon the class hall mount
function SummonClassMount()
    local _, playerClass = UnitClass("player")
    local spellIDs = classMountSpellIDs[playerClass]

        -- Special handling for Druids
        if playerClass == "DRUID" then
            print( GetClassColoredName() .. "s use their flight form as their class mount.")
            return
        end

    if not spellIDs then
        print("No class mount available for " .. GetClassColoredName() .. ".")
        return
    end

    -- Get a list of collected and usable mount IDs
    local knownMounts = GetKnownMountIDsFromSpellIDs(spellIDs)

    if #knownMounts == 0 then
        print("You do not have any class hall mounts unlocked.")
        return
    end

    -- Randomly select one of the collected mounts
    local randomIndex = math.random(#knownMounts)
    local mountID = knownMounts[randomIndex]

    -- Summon the selected mount
    C_MountJournal.SummonByID(mountID)
    -- print("Summoning your class hall mount!")
end
