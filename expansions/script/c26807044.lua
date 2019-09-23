--微光海洋·海伊
function c26807044.initial_effect(c)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26807044,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,26807044)
	e3:SetCondition(c26807044.tkcon)
	e3:SetTarget(c26807044.tktg)
	e3:SetOperation(c26807044.tkop)
	c:RegisterEffect(e3)
end
function c26807044.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c26807044.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,26807045,0,0x4011,2200,600,6,RACE_SEASERPENT,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c26807044.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,26807045,0,0x4011,2200,600,6,RACE_SEASERPENT,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,26807045)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
