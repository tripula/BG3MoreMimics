local md5 = Ext.Require("md5.lua")
local utils = Ext.Require("utils.lua")


ModuleUUID = "c19ca43a-c3c7-4e58-9d00-f7d928e72074"

function Get(ID_name)
	return Mods.BG3MCM.MCMAPI:GetSettingValue(ID_name, ModuleUUID)
end

-- Define global variables
HasPrinted = {}

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, _)
    local party = Osi.DB_PartyMembers:Get(nil)
    for i = #party, 1, -1 do
        TryAddPassive((party[i][1]), "MIMIC_Conversion_Aura")
    end
end)

Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(actor)
    TryAddPassive(actor, "MIMIC_Conversion_Aura")
end)

Ext.Osiris.RegisterListener("MovedBy", 2, "before", function(item, character) 
    local tags = utils.GetTags(item)
    if tags.OsirisTags['ACT1_HAG_ILLUSION'] then
        Osi.ApplyStatus(item, 'HAG_MASK_ILLUSION', 60, 1, character)
    end
end)

Ext.Osiris.RegisterListener("AttackedBy", 7, "before", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
    local tags = utils.GetTags(defender)
    --_P(defender)
    if tags.OsirisTags['ACT1_HAG_ILLUSION'] then
        Osi.ApplyStatus(defender, 'HAG_MASK_ILLUSION', 60, 1, attackerOwner)
    end
end)

Ext.Osiris.RegisterListener("Opened", 1, "before", function(item)
    --_P(item)
    local tags = utils.GetTags(item)
    if tags.OsirisTags['ACT1_HAG_ILLUSION'] then
        Osi.ApplyStatus(item, 'HAG_MASK_ILLUSION', 60, 1, Osi.GetHostCharacter())
        -- Osi.CloseUI(Osi.GetHostCharacter(), "") closeui doesn't work
    end
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    if (status == "AMBUSH_HELPER" and Osi.IsInCombat(object) ~= 1) then
        Osi.RemoveStatus(object, "AMBUSH_IMMUNITY")
        return
    end

    if (status == "TRANSFORM_HELPER") then
       Osi.RequestDelete(object)
       return
    end

    if (status == "CALL_NEIGHBOURS_HELPER") then
        Osi.SetFaction(object, "64321d50-d516-b1b2-cfac-2eb773de1ff6")
        Osi.RemoveStatus(object, "SURPRISED")
        CallNeighbours(object)
    end
end)

Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    if (status == "CONVERT_CHEST_TO_MIMIC") then
        --_P(object)
        local substring = (string.find(object, "CONT") and string.find(object, "Chest")) or (string.find(object, "BuriedChest"))
        if substring then
            --_P("CONVERT", object)
            -- do not mark camp chests
            if string.find(object, "PlayerCampChest") then
                return
            end
            local convertToChestThreshold = GuidToProperty(Get("Seed"), object)
            --_P(object, convertToChestThreshold, utils.PercentToReal(Get("EncounterPercentage")))
            if (utils.PercentToReal(Get("EncounterPercentage")) > convertToChestThreshold) then
                --_P("setting tag to chest", object)
                Osi.SetTag(object, '2a84bac4-3111-43a6-8f0c-9995b6187962')
            end
        end
        return
    end

    if (status == "AMBUSH_HELPER" and Osi.HasActiveStatus(object, "AMBUSH_IMMUNITY") ~= 1) then
        Osi.ApplyStatus(object, "SURPRISED", 1)
        Osi.ApplyStatus(object, "AMBUSH_IMMUNITY", -1)
        return
    end

    if status == "ARMOR_STEAL_HELPER" then
        local stealList = GetEquippedGearSlots(object)
        --_D(stealList)
        -- if only 1 thing left to steal, steal and knock out
        if #stealList == 1 then
            --_P(stealList[1])

            local stealGear = UnequipGearSlot(object, stealList[1], true)
            if stealGear ~= nil then
                Osi.ApplyStatus(object, "ARMOR_STEAL", 0, 100, causee)
                Osi.ApplyStatus(causee, "ABSORB_ITEM", 0, 100, stealGear)
                Osi.ApplyStatus(causee, "POTION_OF_HEALING", 0)
                Osi.ApplyStatus(object, "WYR_POTENTDRINK_BLACKEDOUT", 12)
                --StealItem(UnequipGearSlot(object, "Underwear", true), causee) -- ( ͡° ͜ʖ ͡°)
            end
            return
        end

        for i = 1, #stealList do
            local stealGear = UnequipGearSlot(object, stealList[i], true)
            if stealGear ~= nil then
                Osi.ApplyStatus(object, "ARMOR_STEAL", 0)
                Osi.ApplyStatus(causee, "ABSORB_ITEM", 0, 100, stealGear)
                Osi.ApplyStatus(causee, "POTION_OF_HEALING", 0)
                return
            end
        end
        return
    end

    -- Move the item into the mimic's inventory. (causee = item in this case)
    if (status == "ABSORB_ITEM") then
        Osi.ToInventory(causee, object, 1, 0, 0)
        return
    end

    if (status == "HAG_MASK_ILLUSION") then
        local substring = (string.find(object, "CONT") and string.find(object, "Chest")) or (string.find(object, "BuriedChest"))
        if substring then
            local x,y,z = Osi.GetPosition(object)
            local creatureTplId = "4f694363-716d-48be-bb05-bfcf558a081f"
            local createdGUID = Osi.CreateAt(creatureTplId, x, y, z, 0, 1, '')
            
            if createdGUID then
                --_P(string.format('Successfully spawned %s [%s]', creatureTplId, createdGUID))
                if Get("HarderMimics") == 1 then
                    TryAddSpell(createdGUID, "Target_Vicious_Bite_Mimic")
                end
                Osi.MoveAllItemsTo(object, createdGUID, 0, 0, 1)
                if Osi.HasActiveStatus(Osi.GetHostCharacter(), "HAG_MASK_HAGDEAD") ~= 1 then
                    Osi.ApplyStatus(createdGUID, "CALL_NEIGHBOURS_HELPER", 0)
                end
                Osi.ApplyStatus(object, "TRANSFORM_HELPER", 0)
            else
                _P((string.format('Failed to spawn %s', creatureTplId)))
                Osi.ClearTag(object, "2a84bac4-3111-43a6-8f0c-9995b6187962")
                Osi.RemoveStatus(object, "HAG_MASK_ILLUSION")
                Osi.Die(object)
            end
        end
        return
    end
end)

function GetEquippedGearSlots(character)
    local slots = {"Helmet", "Gloves", "Boots", "Cloak", "Breast"}
    local equippedGearSlots = {}
    for i = 1, #slots do
        local gearPiece = Osi.GetEquippedItem(character, slots[i]);
        if gearPiece ~= nil then
            table.insert(equippedGearSlots, slots[i])
        end
    end
    return equippedGearSlots
end

function UnequipGearSlot(character, slot, forceUnlock)
    local gearPiece = Osi.GetEquippedItem(character, slot);
    if gearPiece ~= nil then
        if forceUnlock then
            Osi.LockUnequip(gearPiece, 0)
        end
        Osi.Unequip(character, gearPiece)
    end

    return gearPiece
end

  -- Function to convert GUID to a property value in range [0, 1], with an optional seed
function GuidToProperty(guid, seed)
    -- Step 1: Concatenate the seed with the GUID (if a seed is provided)
    local input = guid
    if seed then
        input = seed .. guid
    end
    
    -- Step 2: Hash the combined input using MD5
    local hash = md5.sum(input)
    
    -- Step 3: Normalize the hash value to a float between 0 and 1
    -- We'll use the first 8 bytes of the hash to create a floating-point number
    local byte1, byte2, byte3, byte4, byte5, byte6, byte7, byte8 = string.byte(hash, 1, 8)
    
    -- Combine bytes to form a 64-bit integer
    local hash_int = ((byte1 * 2^56) + (byte2 * 2^48) + (byte3 * 2^40) + (byte4 * 2^32)
                    + (byte5 * 2^24) + (byte6 * 2^16) + (byte7 * 2^8) + byte8)
    
    -- Normalize to the range [0, 1]
    local max_int = 2^64 - 1
    local normalized_value = hash_int / max_int
    
    return normalized_value
end

function CallNeighbours(mimic)
    Osi.ApplyStatus(mimic, "AMBUSH_AURA", 1)
    Osi.ApplyStatus(mimic, "HAG_MASK_HAGDEAD", 0)
end

-- Add spell if actor doesn't have it yet
function TryAddSpell(actor, spellName)
    if  Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end

-- Add passive if actor doesn't have it yet
function TryAddPassive(actor, passiveName)
    if Osi.HasPassive(actor, passiveName) == 0 then
        Osi.AddPassive(actor, passiveName)
    end
end

print("MoreMimics is loaded successfully")

