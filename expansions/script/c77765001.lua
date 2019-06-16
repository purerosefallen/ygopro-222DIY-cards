local m=77765001
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
function cm.initial_effect(c)
	local function difficulty_filter(c)
		return Kaguya.IsDifficulty(c)-- and c:GetActivateEffect():IsActivatable(tp,true,true)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 and Duel.IsExistingMatchingCard(difficulty_filter,tp,LOCATION_DECK,0,1,nil) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,difficulty_filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			local te=tc:GetActivateEffect()
			Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			if te then
				te:UseCountLimit(tp,1,true)
			end
		end
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(function(e,c)
		return Kaguya.IsDifficulty(c)
	end)
	e2:SetValue(function(e,te,c)
		local ec=te:GetOwner()
		return ec~=e:GetOwner() and ec~=c
	end)
	c:RegisterEffect(e2)
end
