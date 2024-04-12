local success, func = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Bovanlaarhoven/Project-Validus-v2/main/utils/func.lua"))()
end)

if success then
    local testVector = Vector3.new(10, 10, 10)
    local screenPos, onScreen = GetScreenPosition(testVector)
    local testPlayer = plrs:GetPlayers()[2]
    print(testPlayer.Name) 
    print("Screen position:", screenPos)
    print("On screen:", onScreen)
    
    print("Is player alive:", func.IsAlive(testPlayer))
    
    print("Is player on different team:", func.TeamCheck(testPlayer))
    
    local mousePos = GetMousePosition()
    print("Mouse position:", mousePos)
    
    local gun = func.GetGun(testPlayer)
    print("Player's gun:", gun)
    
    print("Is player visible:", func.IsPlayerVisible(testPlayer))
    
    local testChance = 50
    print("Did hit chance succeed:", func.HitChance(testChance))
    
    local testOrigin = Vector3.new(0, 0, 0)
    local testPos = Vector3.new(10, 10, 10)
    print("Direction vector:", func.Direction(testOrigin, testPos))
    return func
else
    print("Error loading func.lua:", func)
end
