local utils = { }

function utils.ReadJsonFile()
    -- Load the file and get its content
    local status, json = pcall(Ext.IO.LoadFile, "MoreMimics.json")

    -- Check if the file was loaded successfully
    if not status or not json then
        print(string.format("INFO: Couldn't load: %%LOCALAPPDATA%%\\Larian Studios\\Baldur's Gate 3\\Script Extender\\%s. Applying default configuration", json or "MoreMimics.json"))

        -- If the file is not present or fails to load, write the default config file
        WriteDefaultConfig()

        -- Try to load the file again after writing the default config
        status, json = pcall(Ext.IO.LoadFile, "MoreMimics.json")

        -- If the file still fails to load, return nil
        if not status or not json then
            print("ERROR: Failed to load config file after writing default config")
            return nil
        end
    end

    -- Parse the JSON string into a Lua table
    local status, result = pcall(Ext.Json.Parse, json)

    -- Check if the JSON was parsed successfully
    if not status then
        print(string.format("ERROR: Failed to parse JSON: %s", result)) -- result contains the error message
        return nil
    end

    -- Assign the result to the global ConfigTable
    ConfigTable = result

    -- Print the entire table for debugging only if HasPrinted is false
    if not HasPrinted["ConfigTable"] and Ext.Debug.IsDeveloperMode() then
        _D(ConfigTable)
        HasPrinted["ConfigTable"] = true
    end
end

function WriteDefaultConfig()
    -- Define the default configuration
    local defaultConfig = '{"EncounterPercentage": 20,"Seed": "chesty","HarderMimics": 1}'
    -- Write the default configuration to the file
    Ext.IO.SaveFile("MoreMimics.json", defaultConfig)
end

function utils.PercentToReal(pct)
    -- Ensure the input is within the valid range of 0 to 100
    if pct < 0 then
        return 0
    end
    
    if pct > 100 then
        return 100
    end
    -- Convert the integer to a real number between 0 and 1
    return pct / 100
end

---Delay a function call by the given time
---@param ms integer
---@param func function
function utils.DelayedCall(ms, func)
    local Time = 0
    local handler
    handler = Ext.Events.Tick:Subscribe(function(e)
        Time = Time + e.Time.DeltaTime * 1000 -- Convert seconds to milliseconds

        if (Time >= ms) then
            func()
            Ext.Events.Tick:Unsubscribe(handler)
        end
    end)
end

function utils.GetTags(object)
    local tags = {
        Tags = {},
        OsirisTags = {},
        TemplateTags = {},
    }
    local esvObject = Ext.Entity.Get(object)
    if object ~= nil then
        for _, tag in pairs(esvObject.Tag.Tags) do
            local tagData = Ext.StaticData.Get(tag, "Tag")
            if tagData ~= nil then
                tags.Tags[tagData.Name] = tag
            end
        end

        for _, tag in pairs(esvObject.ServerOsirisTag.Tags) do
            local tagData = Ext.StaticData.Get(tag, "Tag")
            if tagData ~= nil then
                tags.OsirisTags[tagData.Name] = tag
            end
        end

        for _, tag in pairs(esvObject.ServerTemplateTag.Tags) do
            local tagData = Ext.StaticData.Get(tag, "Tag")
            if tagData ~= nil then
                tags.TemplateTags[tagData.Name] = tag
            end
        end
    end

    return tags
end

return utils