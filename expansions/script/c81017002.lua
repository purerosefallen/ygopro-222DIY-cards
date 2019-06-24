--啦啦队员·高山纱代子
function c81017002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81017002)
	e1:SetCondition(c81017002.spcon)
	c:RegisterEffect(e1)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c81017002.sumlimit)
	c:RegisterEffect(e3)
end
function c81017002.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x819)
end
function c81017002.spfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c81017002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or Duel.IsExistingMatchingCard(c81017002.spfilter2,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.IsExistingMatchingCard(c81017002.spfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c81017002.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsRace(RACE_FAIRY)
end
