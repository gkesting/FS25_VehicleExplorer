
local modDirectory = g_currentModDirectory

-- Create a base table
VeExList = {}

-- Create a metatable to add class functionality and tell the system that VeExList class will be a subclass of HUDDisplayElement
local VeExList_mt = Class(VeExList, HUDDisplayElement)

---The Class constructor
-- @includeCode
function VeExList.new()
    -- first create the background overlay
    local backgroundOverlay = VeExList.createBackground()

    -- HUDDisplayElement takes the overlay as first parameter to be created
    -- Also pass the class metatable so subclass knows about this one
    local self = VeExList:superClass().new(backgroundOverlay, nil, VeExList_mt)

    self.vehicle = nil

    -- initialize base values with ui scale 1
    self:applyValues(1)

    -- return the object reference
    return self
end

---Sets the current vehicle
-- @param table vehicle Vehicle reference or nil (not controlling a vehicle)
-- @includeCode
function VeExList:setVehicle(vehicle)
    -- check if the passed vehicle has a mileage counter
    -- if no ignore it
    --if vehicle ~= nil and vehicle.getDrivenDistance == nil then
--         vehicle = nil
--     end

--     self.vehicle = vehicle
end

---Draws the mileage display
-- @includeCode
function VeExList:draw()
    --We dont need to draw anything if no vehicle is set (e.g. if player is walking around)
--     if self.vehicle == nil then
--         return
--     end

    --Class the draw function of the super class to render the background
    VeExList:superClass().draw(self)

--     local textBG = "Hallo Welt BG"
--     local text = "Hallo Welt"

--     --Store the color in a local for faster access
--     local textColor = VeExList.COLOR.TEXT
--     local textColorBG = VeExList.COLOR.TEXT_BACKGROUND
--     local textSize = self.textSize

--     --Get the position of the display
--     local posX, posY = self:getPosition()
--     posX = posX + self.textOffsetX
--     posY = posY + self.textOffsetY

--     --Disable bold textrendering
--     setTextBold(false)
--     --Set textrendering to right alignment
--     setTextAlignment(RenderText.ALIGN_RIGHT)
--     --Set the color of the textrendering for background text
--     setTextColor(textColorBG[1], textColorBG[2], textColorBG[3], textColorBG[4])
--     --Render the background text
--     renderText(posX, posY, textSize, textBG)

--     --Set the color of the textrendering for the text
--     setTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
--     --Render the text
--     renderText(posX, posY, textSize, text)

--     --As text rendering functions are using a global scope we need to reset all our changes
--     --Reset text alignment to left
--     setTextAlignment(RenderText.ALIGN_LEFT)
--     --Reset text color to white
--     setTextColor(1, 1, 1, 1)
end

------------------------------------------------------------------------------------------------------------------------
-- Scaling
------------------------------------------------------------------------------------------------------------------------

---Set this element's UI scale factor.
-- @param float uiScale UI scale factor
-- @includeCode
function VeExList:setScale(uiScale)
    VeExList:superClass().setScale(self, uiScale, uiScale)

    --Reposition the mileage display if ui scale changed
    local posX, posY = VeExList.getBackgroundPosition(uiScale)
    self:setPosition(posX, posY)

    --Recalculate the offset values
    self:applyValues(uiScale)
end

---Calculate some text values with a given ui scale
-- @param float uiScale UI scale factor
-- @includeCode
function VeExList:applyValues(uiScale)
    --Convert our pixel values stored in VeExList.POSITION.TEXT_OFFSET to normalized screen values
    --getNormalizedScreenValues also take care abour aspect ratios. It assumes that the hud/ui is designed for Full-HD (1920x1080)
    local textOffsetX, textOffsetY = getNormalizedScreenValues(unpack(VeExList.POSITION.TEXT_OFFSET))
    local _, textSize = getNormalizedScreenValues(0, VeExList.SIZE.TEXT)

    self.textOffsetX = textOffsetX*uiScale
    self.textOffsetY = textOffsetY*uiScale
    self.textSize = textSize*uiScale
end

---Get the scaled background position.
-- @param float uiScale UI scale factor
-- @includeCode
function VeExList.getBackgroundPosition(uiScale)
    local width, _ = getNormalizedScreenValues(unpack(VeExList.SIZE.SELF))
    local offsetX, offsetY = getNormalizedScreenValues(unpack(VeExList.POSITION.OFFSET))
    local posX = 1 - width*uiScale + offsetX*uiScale
    local posY = offsetY*uiScale

    return posX, posY
end

---Create the background overlay.
-- @includeCode
function VeExList.createBackground()
    local posX, posY = VeExList.getBackgroundPosition(1)
    local width, height = getNormalizedScreenValues(unpack(VeExList.SIZE.SELF))

    --We need to convert the given filepath and add the mod directory to get the final absolute path
    local filename = Utils.getFilename("hud/VeExListBackground.png", modDirectory)

    --Creating a new overlay
    local overlay = Overlay.new(filename, posX, posY, width, height)
    return overlay
end

---Element sizes
VeExList.SIZE = {
    SELF = {400, 200},
    TEXT = 17
}

---Element positions
VeExList.POSITION = {
    OFFSET = {-500, -200},
    TEXT_OFFSET = {115, 10}
}

---Element colors
VeExList.COLOR = {
    TEXT = {1, 1, 1, 1},
    TEXT_BACKGROUND = {0.15, 0.15, 0.15, 1}
}