--/Services

--/Modules
local attackData = require(game.ReplicatedStorage.Modules.Manager.AttackData)
local module = {}
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes").Misc.Stamina
--/Variables

--/Methods
function module.checkStamina(Character, moduleName, skill, loop)
	local staminaData = attackData.getData(moduleName, skill)

	if staminaData then
		if loop then
			if staminaData.Stamina <= Character.States:GetAttribute("Stamina") then
				task.wait()
				print(Character.HumanoidRootPart:FindFirstChild("FireFlyHold"))
				task.spawn(function()
					while
						staminaData.Stamina <= Character.States:GetAttribute("Stamina")
						and Character.HumanoidRootPart:FindFirstChild("FireFlyHold")
					do
						Character.States:SetAttribute(
							"Stamina",
							Character.States:GetAttribute("Stamina") - staminaData.Stamina
						)
						task.wait(0.1)
						print("draining")
					end
					if Character.HumanoidRootPart:FindFirstChild("FireFlyHold") then
						Character.HumanoidRootPart:FindFirstChild("FireFlyHold"):Destroy()
					end
				end)
			end
		else
			if staminaData.Stamina <= Character.States:GetAttribute("Stamina") then
				Character.States:SetAttribute("Stamina", Character.States:GetAttribute("Stamina") - staminaData.Stamina)
			end
		end
	end
end

function module.increaseStamina(Character)
	Character:SetAttribute("IncreasingStamina", true)
	local staminaDebounce = false

	while
		Character
		and Character.Humanoid.Health > 0
		and Character.States:GetAttribute("Stamina") < Character.States:GetAttribute("MaxStamina")
		and not staminaDebounce
	do
		staminaDebounce = true
		task.wait(1)
		staminaDebounce = false
		if
			Character.States:GetAttribute("Stamina") < Character.States:GetAttribute("MaxStamina")
			and Character.Humanoid.FloorMaterial ~= Enum.Material.Air
		then
			if
				Character.States:GetAttribute("Stamina") + (Character.States:GetAttribute("MaxStamina") / 10)
				> Character.States:GetAttribute("MaxStamina")
			then
				Character.States:SetAttribute(
					"Stamina",
					Character.States:GetAttribute("Stamina")
						+ (Character.States:GetAttribute("MaxStamina") - Character.States:GetAttribute("Stamina"))
				)
				print(Character.States:GetAttribute("Stamina"))
			else
				Character.States:SetAttribute(
					"Stamina",
					Character.States:GetAttribute("Stamina") + (Character.States:GetAttribute("MaxStamina") / 10)
				)
				print(Character.States:GetAttribute("Stamina"))
			end
		end
	end
	Character:SetAttribute("IncreasingStamina", nil)
end

Remote.OnServerEvent:Connect(function(plr)
	local Character = plr.Character
	local States = Character.States

	States:GetAttributeChangedSignal("Stamina"):Connect(function()
		if not Character:GetAttribute("IncreasingStamina") then
			module.increaseStamina(Character)
		end
	end)
end)

return module
