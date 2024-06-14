local md5 = Ext.Require("md5.lua")
local utils = Ext.Require("utils.lua")


ModuleUUID = "c19ca43a-c3c7-4e58-9d00-f7d928e72074"

function Get(ID_name)
	return Mods.BG3MCM.MCMAPI:GetSettingValue(ID_name, ModuleUUID)
end

function GetSettingsPrefix(chest)
    if Get("MimicsSettingsType") == "overall" then
        return "General"
    else
        return GetCategory(Chests, GetDisplayName(chest))
    end
end

-- Define chest type
Poor = {"h17976553gc896g4643gb06ag4a62f59fef20","h187af234g5438g4050gbee2g1d229c878be6","h18af59d3gd122g4d76gb718gad1b01c54184",
"h313d9cd8gcb9dg4da7ga368g9587a1679104","h357489cegd8d5g410eg95b2g97d8287b9ad7","h3b50d7a5gf953g4257gbf49gb9dd723e68ad",
"h4dfec4f3g853dg4137g9359g9b48d17d75ba","h5697c0a8g206bg4155g8947g26be543e08ff","h93641e6egf930g476cgacbdg8e614c7f4c1b",
"h9808b932g7dc2g464egbe05g567e9e0548b2","hb57896dcgc64cg4dc0gbca9g038f002cb535","hd17b3bf9g9359g4476g84b2g9eb9a2ff826e",
"hdafd441fg4e4cg4602g80f9geb1702e93d8f","he1374cc4g4d12g4293ga649gd69db1f8866c","he8c8e839g9ce1g45bfgba84g2eaddaf0f150",
"hf0beb07fg7a7bg4cd8ga3c9g73e62b22d6e7","hf4bae2f7gb6e8g4f8cgacf6g291a1f5a29ea","h6a9b3b32g6396g4aafg99edg9368df2421cb",
"h7bb9afb4g98c4g4519gbc23g03799679a8f1","h9317e1e3gfc5eg482ag8020g6e2277d16354","ha3590bc7g27b5g4d81g9a16g8d1e653cd787",
"haa175368g719bg4fd0g91dcgd8f64a61db06","hd80086a6g8d0bg4f08g87c0g3291a7b1d16b","hce8cc4edgd642g4a34gbab2g4f728d5ee534",
"h333df48eg4ec0g43f5ga51eg060507a3a745","h52cfff01ge443g4f2cg8879g046762a1db8e","hbf0be390g47d8g44c8g9012g76d639df51fe",}

Ok = {"h0cbd6714g0052g438agb735g3983f72be4fe","h147514e7g7cb1g4f3dg9971g33e18dd9a05d","h2def6237g88a4g4da3g92cfgd2fb7db0e312",
"hb5583286gd86fg40a1ga231gb2fbc2d4d6f3","hbbc309d3g59f1g4884gb4aag67014ed91462","hf8f20e43gc9f5g4c86g9598gcd0e8a36a70d",
"hfb8f9f27g57b4g45dbg82aegf68b9772a7d6","h5bd4d94agdc2fg4260gaddeg36e53446d685","h48d19f91g535bg46d2g967fge0ad5e119212",
"heda8d26egfb09g4113gad26g5fa2b60a65c3","h180976f0g0e4cg4240g851cg5584e32029d2","ha92a806cgbda3g4d8bg84bega9350d424993",
"h42cf1b05g5c7cg45c4g86aeg77f3d26d069c","h6c9d8242g3ec9g4f49ga9c6gae77e563b90b","hebaec8d0ge9e4g4af8g9db9g5f4766c93433",
"hff071a90g3d26g459eg82a7g932988901d99","h5660455cg3d5cg4600g8df8g21f9ce119734","h4d4f5977g3020g4552gb192g21745e5370f0",
"h64f8fd00g50dcg4c9dg8656g1c5f05d29bc1","h660b3a69g7042g4d33gaf77g383ae21a27d2","h8fc9c16bg939ag4c7agb342gdb46d17fbae1",
"hd856662fg0f5eg4dedga623g7626c5b33800",}

Good = {"h09d80ebcg9d1fg4d43g85b0gdb0bd62ab079","h1e364f5eg4284g46c4g9337g640488392f7e","h201dadb4g9689g45baga115g0be24ab06ac0",
"h68d138f3gf5e7g44e7ga765g11d38b6886a0","h6d0c86e9g1334g462ag9135gdf65b0f746a0","h8b84795bg6560g4ab6gbca4g8e49bd3dcb27",
"h928998a4g317dg4e8dg8ca6gaa56645fd761","h9dd5cb1ag9659g4ee1g8bbegbe95416c7967","ha3bdd816g40a5g4edfgbab2g31612a3da7ae",
"ha79110a4ga594g4fdfg890bge8f570194aa5","hafb89c59gcc34g464ag9c4eg4539f6accb22","hc2f9ce16g00aag4755g9a5egeada47dac05e",
"hcb37303bg3d25g4fd2gaaf0g0a0e57e7ff19","hde142061g864bg4037g9c91gec820407a5f9","he1990708gaf30g424fga524gb23c96e36125",
"he82fd949geca6g4739ga115g9463b8d7b9d6","h071c628fg73e8g44aaga5d2g7beb90ab4645","h0b71551eg712bg4556g9a0dg9a5c8332c1be",
"h254eb416ge52ag4ba7ga7a3ge80099d2dde0","h69fee60dg6500g4afega16cg68217f1c935c","hef66271cg3de1g4a24gbc31g75d8b0c2d517",
"hf04a53cfg4467g4c92g8e07gf3710d64afdc","hf1c04abagf9c1g4de1gb61dgb23936783755","h1eeb2c44g49d7g4aa9g859dg1b69a433ecd8",
"hed6ffb9dgc443g462cg8c6fga6bf1ee216fb","h21935e9bg6edfg46bcg97b8g0d81c24b8294","h45242012g91a4g4056g8b6fg93ddcf32d82f",
"h73f35aebg2cf5g4857gbd16g9e9b40ac5387","h815107b4g6ca9g4016ga49agb28ff6d8a96f","h98b425afgd831g42e4gb5ebg5f8f1c3fff74",
"h9bc4dae7gc07eg466cga283g5baaa221cce7","h9f7c4ed0gd0cbg4a84g863dgff21c6c64add",}

Chests = {Poor = Poor, Ok = Ok, Good = Good}

-- Define global variables
HasPrinted = {}

Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", function(levelName, _)
    local party = Osi.DB_PartyMembers:Get(nil)
    for i = #party, 1, -1 do
        TryRemovePassive((party[i][1]), "MIMIC_Conversion_Aura")
        TryRemoveStatus((party[i][1]), "MIMIC_AURA")
    end
end)

Ext.Osiris.RegisterListener("CharacterJoinedParty", 1, "after", function(actor)
    TryRemovePassive(actor, "MIMIC_Conversion_Aura")
    TryRemoveStatus(actor, "MIMIC_AURA")
end)

Ext.Osiris.RegisterListener("MovedBy", 2, "before", function(item, character)
    --_P("MovedBy", item, character)
    MarkForMimicConversion(item, character)
end)

Ext.Osiris.RegisterListener("AttackedBy", 7, "before", function(defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
    --_P("AttackedBy", defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
    if (damageCause == "Attack" and damageAmount > 0) then
        --_P("AttackedBy", defender, attackerOwner, attacker2, damageType, damageAmount, damageCause, storyActionID)
        MarkForMimicConversion(defender, attackerOwner)
    end
end)

Ext.Osiris.RegisterListener("TemplateOpening", 3, "before", function(itemTemplate, item2, character)
    --_P(itemTemplate, item2, character)
    MarkForMimicConversion(item2, character)
end)

Ext.Osiris.RegisterListener("StatusRemoved", 4, "after", function(object, status, causee, storyActionID)
    --_P("REMOVED:", status)
    if (status == "AMBUSH_HELPER" and Osi.IsInCombat(object) ~= 1) then
        Osi.RemoveStatus(object, "AMBUSH_IMMUNITY")
        return
    end

    if (status == "HAG_MASK_HAGDEAD") then
        Osi.RemoveStatus(object, "MIMIC_AURA")
        return
    end

    if (status == "TRANSFORM_HELPER") then
        TransformIntoMimic(object, causee)
        --Osi.RequestDelete(object)
        return
    end

    if (status == "CALL_NEIGHBOURS_HELPER") then
        Osi.SetFaction(object, "64321d50-d516-b1b2-cfac-2eb773de1ff6")
        Osi.RemoveStatus(object, "SURPRISED")
        CallNeighbours(object)
        return
    end
end)

function GetCategory(tbl, value)
	local function searchTable(value, tbl)
        for name, subtable in pairs(tbl) do
            if type(subtable) == "table" then
				local result = searchTable(value, subtable)
                if result then
                    return name
                end
            elseif string.find(value, subtable) then
                return name
            end
        end
	end
    for name, subtable in pairs(tbl) do
        if type(subtable) == "table" then
            print("look into "..name)
            if searchTable(value, subtable) then
                return name
            end
        end
    end
end


Ext.Osiris.RegisterListener("StatusApplied", 4, "after", function(object, status, causee, storyActionID)
    --_P(object, status)
    -- When the Player wears the Hag Mask, Transform nearby chests to mimics
    if (status == "HAG_MASK_HAGDEAD") then
        Osi.ApplyStatus(object, "MIMIC_AURA", -1)
        return
    end

    if (status == "TRANSFORM_HELPER") then
        Osi.Die(object)
        Osi.RemoveStatus(object, "TRANSFORM_HELPER", causee)
    end

    if (status == "CONVERT_CHEST_TO_MIMIC") then
        MarkForMimicConversion(object, causee)
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
                --Osi.ApplyStatus(causee, "ABSORB_ITEM", 0, 100, UnequipGearSlot(object, "Underwear", true)) -- ( ͡° ͜ʖ ͡°)
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

function CallNeighbours(mimic)
    Osi.ApplyStatus(mimic, "AMBUSH_AURA", 0)
    Osi.ApplyStatus(mimic, "MIMIC_AURA", 0)
end

-- Add spell if actor doesn't have it yet
function TryAddSpell(actor, spellName)
    if  Osi.HasSpell(actor, spellName) == 0 then
        Osi.AddSpell(actor, spellName)
    end
end

-- Uninstall the old passive
function TryRemovePassive(actor, passiveName)
    if Osi.HasPassive(actor, passiveName) ~= 0 then
        Osi.RemovePassive(actor, passiveName)
        --_P("Succesfully removed passive", passiveName, "on", actor)
    end
end

function TryRemoveStatus(actor, statusName)
    if Osi.HasActiveStatus(actor, statusName) ~= 0 then
        Osi.RemoveStatus(actor, statusName)
        --_P("Succesfully removed status", statusName, "on", actor)
    end
end

---Mark a chest to turn into a Mimic after its buff expires
---@param object string
---@param causee string
function MarkForMimicConversion(object, causee)
    -- only transform buried chests or generic chests.
    local isChest = (string.find(object, "CONT") and string.find(object, "Chest")) or (string.find(object, "BuriedChest"))
    if isChest then
        local settingsPrefix = GetSettingsPrefix(object)

        --_P("CONVERT", object)
        -- do not mark camp chests
        if string.find(object, "PlayerCampChest") then
            return false
        end
        local convertToChestThreshold = GuidToProperty(Get("Seed"), object)
        --_P(object, convertToChestThreshold, utils.PercentToReal(Get("EncounterPercentage")))
        if (utils.PercentToReal(Get(settingsPrefix.."_EncounterPercentage")) > convertToChestThreshold) then
            Osi.ApplyStatus(object, "TRANSFORM_HELPER", 6, 100, causee)
        end

        return true
    end

    return false
end

---Attempt to Transform an object into a Mimic
---@param object string
---@param causee string
function TransformIntoMimic(object, causee)
    if Osi.IsDead(object) == 1 then
        --_P((string.format('Object died, wont spawn')))

        return
    end

    local x,y,z = Osi.GetPosition(object)
    local creatureTplId = "4f694363-716d-48be-bb05-bfcf558a081f"
    local createdGUID = Osi.CreateAt(creatureTplId, x, y, z, 0, 1, '')

    if createdGUID then
        --_P(string.format('Successfully spawned %s [%s]', creatureTplId, createdGUID))
        if (Osi.HasActiveStatus(causee,"AMBUSH_IMMUNITY") == 1 or Osi.HasPassive(causee, "Alert") == 1 or Osi.HasPassive(causee, "Surprise_Immunity") == 1) and Osi.IsPlayer(causee) == 1 then
            Osi.QRY_StartDialogCustom_Fixed("GLO_PAD_Mimic_Revealed_55471c86-3b69-ccae-d0e3-e8749cf41d9e", causee, "NULL_00000000-0000-0000-0000-000000000000", "NULL_00000000-0000-0000-0000-000000000000", "NULL_00000000-0000-0000-0000-000000000000", "NULL_00000000-0000-0000-0000-000000000000", "NULL_00000000-0000-0000-0000-000000000000", 1, 1, -1, 1 )
        end

        if Get("General_HarderMimics") then
            TryAddSpell(createdGUID, "Target_Vicious_Bite_Mimic")
        end
        Osi.MoveAllItemsTo(object, createdGUID, 0, 0, 1)
        -- Surprise player if no mask is worn
        if Osi.HasActiveStatus(causee, "HAG_MASK_HAGDEAD") ~= 1 then
            Osi.ApplyStatus(createdGUID, "CALL_NEIGHBOURS_HELPER", 0)
            if Osi.HasActiveStatus(causee,"AMBUSH_IMMUNITY") ~= 1 and Osi.HasPassive(causee, "Alert") ~= 1 and Osi.HasPassive(causee, "Surprise_Immunity") ~= 1 and Osi.IsPlayer(causee) == 1 then
                Osi.QRY_StartDialogCustom_Fixed("GLO_PAD_Mimic_Surprised_cb5f94c8-ee5b-c17a-959c-64bc6f88b417", causee, "NULL_00000000-0000-0000-0000-000000000000", "NULL_00000000-0000-0000-0000-000000000000", "NULL_00000000-0000-0000-0000-000000000000", "NULL_00000000-0000-0000-0000-000000000000", "NULL_00000000-0000-0000-0000-000000000000", 1, 1, -1, 1 )
            end
        end
    else
        _P((string.format('Failed to spawn %s', creatureTplId)))
    end

    Osi.Die(object)
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

print("MoreMimics is loaded successfully")