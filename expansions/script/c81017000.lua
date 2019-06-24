--高山纱代子
function c81017000.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81017000)
	e1:SetCondition(c81017000.spcon)
	c:RegisterEffect(e1)
end
function c81017000.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c81017000.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c81017000.cfilter,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c81017000.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
