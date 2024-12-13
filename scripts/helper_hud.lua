-- Primarily reused the code from Manuel Leithner


---We need to append a anonymous function to HUD:createDisplayComponents
-- It creates all required display components.
-- Now we are able to create a new instance of our MileageDisplay and add it to the HUD
-- @param uiScale Current UI scale
-- @includeCode
HUD.createDisplayComponents = Utils.appendedFunction(HUD.createDisplayComponents, function(self, uiScale)
    self.veexList = VeExList.new()
    self.veexList:setScale(uiScale)
    table.insert(self.displayComponents, self.veexList)
end)


---We need to append a anonymous function to HUD:drawControlledEntityHUD
-- It draws the HUD components for the currently controlled entity (player or vehicle).
-- @includeCode
HUD.drawControlledEntityHUD = Utils.appendedFunction(HUD.drawControlledEntityHUD, function(self)
    if self.isVisible then
        self.veexList:draw()
    end
end)


---We need to append a anonymous function to HUD:setControlledVehicle
-- It sets current controlled vehicle.
-- @param table vehicle Vehicle reference or nil (not controlling a vehicle)
-- @includeCode
--HUD.setControlledVehicle = Utils.appendedFunction(HUD.setControlledVehicle, function(self, vehicle)
--    self.veexList:setVehicle(vehicle)
--end)