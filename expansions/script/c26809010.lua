--冷清的飘落
function c26809010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26809010+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26809010.target)
	e1:SetOperation(c26809010.activate)
	c:RegisterEffect(e1)
end
function c26809010.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c26809010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26809010.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c26809010.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local d=Duel.TossDice(tp,1)
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-d)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
	end
end
