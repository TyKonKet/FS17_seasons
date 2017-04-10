----------------------------------------------------------------------------------------------------
-- SNOW ADMIRER
----------------------------------------------------------------------------------------------------
-- Purpose:  Visibility of objects dependent on snow
-- Authors:  Rahkiin
--
-- Copyright (c) Realismus Modding, 2017
----------------------------------------------------------------------------------------------------

ssSnowAdmirer = {}
getfenv(0)["ssSnowAdmirer"] = ssSnowAdmirer

local ssSnowAdmirer_mt = Class(ssSnowAdmirer)

function ssSnowAdmirer:onCreate(id)
    g_currentMission:addUpdateable(ssSnowAdmirer:new(id))
end

function ssSnowAdmirer:new(id)
    local self = {}
    setmetatable(self, ssSnowAdmirer_mt)
    self.id = id

    -- If attribute is set to false, it will only show when there is NO snow
    self.showWhenSnow = Utils.getNoNil(getUserAttribute(id, "snow"), true)

    g_currentMission.environment:addWeatherChangeListener(self)

    return self
end

function ssSnowAdmirer:delete()
    if g_currentMission.environment ~= nil then
        g_currentMission.environment:removeWeatherChangeListener(self)
    end
end

function ssSnowAdmirer:updateVisibility()
    setVisibility(self.id, g_seasons.weather:getSnowHeight() > 0)
end

function ssSnowAdmirer:weatherChanged()
    self:updateVisibility()
end

function ssSnowAdmirer:update(dt)
    if self.once ~= true then
        self:updateVisibility()

        self.once = true
    end
end
