local m=77765030
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=true
function cm.initial_effect(c)
	local ex=Kaguya.ContinuousCommonEffect(c,EVENT_FREE_CHAIN,function(e,tp,eg,ep,ev,re,r,rp)
		for p=0,1 do
			local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
			if #g>0 and g:FilterCount(Card.IsPublic,nil)==#g then return true end
		end
		return false
	end,Senya.DescriptionCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:GetFlagEffect(m+200)==0 end
		c:RegisterFlagEffect(m+200,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	end),true)
	ex:SetType(EFFECT_TYPE_QUICK_O)
	ex:SetDescription(m*16+2)
	ex:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	c:RegisterEffect(ex)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_HAND,0,nil)
		if chk==0 then return #g>0 end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_HAND,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		end
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(Senya.DescriptionCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return Duel.GetFlagEffect(tp,m)-Duel.GetFlagEffect(tp,m+100)==0 end
		Duel.RegisterFlagEffect(tp,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end))
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
		if chk==0 then return #g>0 end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
		if #g>0 then
			local sg=g:RandomSelect(tp,1)
			local tc=sg:GetFirst()
			if not tc:IsPublic() then
				for _,code in ipairs({
					EFFECT_PUBLIC,
					EFFECT_CANNOT_TRIGGER,
					EFFECT_CANNOT_SSET,
					EFFECT_CANNOT_MSET
				}) do
					local ex=Effect.CreateEffect(e:GetHandler())
					ex:SetType(EFFECT_TYPE_SINGLE)
					ex:SetCode(code)
					ex:SetValue(1)
					ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					ex:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(ex)

				end
			end
		end
	end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+1)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(Senya.DescriptionCost(Senya.DiscardHandCost(1)))
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(tp,m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end)
	c:RegisterEffect(e2)
end
