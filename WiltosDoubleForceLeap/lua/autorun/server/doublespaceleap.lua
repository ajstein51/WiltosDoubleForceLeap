hook.Add("SetupMove", "WOSDoubleForceJump", function(ply, mvd, cmd)
	-- teams allowed to do the double jump, to add teams just copy and paste your job name from jobs.lua
	local allowedTeams = { 'Shadow Guard', 'Sovereign Protector', 'Darth', 'Darth Vader' } 
	
	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) then return end -- Check if weapon is valid
	if not wep.IsLightsaber then return end -- Is the weapon a lightsaber?
	if wep:GetForce() < 30 then return end -- Does the lightsaber have at least 10 force power?

	if ply:OnGround() then 
		ply.ForceJumpLevel = 0
		return 
	end
	
	if not mvd:KeyPressed(IN_JUMP) then return end -- Is the player jumping?
	
	ply.ForceJumpLevel = ply.ForceJumpLevel + 1
	
	if ply.ForceJumpLevel > 1 then return end -- Has the player already double jumped?
	
	-- check if the person attempting to double jump is in allowedTeams
	for k, v in ipairs(player.GetAll()) do 
		if v:Nick() == ply:Nick() then
			-- check if hes on a job within allowedTeams
			local flag = 0
			for k1, v1 in ipairs(allowedTeams) do 
				if team.GetName(Entity(k):Team()) == v1 then
					flag = 1
				end -- end of if
			end -- end of for
			if flag == 0 then return end -- The user isnt in allowed teams, exit hook
		end -- end of if
	end -- end of for
	
	-- They are allowed, set lower their force, do the animation, and launch the player
	wep:SetForce( wep:GetForce() - 30 )
	wep:CallOnClient( "ForceJumpAnim", "" )

	mvd:SetVelocity( mvd:GetVelocity() + ply:GetAimVector() * 512 + Vector( 0, 0, 512 ) )

	wep:PlayWeaponSound( "lightsaber/force_leap.wav" )
	ply:SetSequenceOverride( "roll_forward", 2 )
end)