--踏浪·白上吹雪
function c81006032.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon bgm
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c81006032.sumcon)
	e0:SetOperation(c81006032.sumsuc)
	c:RegisterEffect(e0)
	--spsummon
	local e1=aux.AddRitualProcEqual2(c,c81006032.ritfilter,LOCATION_REMOVED)
	e1:SetCountLimit(1,81006032)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(0)
	e1:SetRange(LOCATION_MZONE)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,81006932)
	e2:SetCondition(c81006032.tkcon)
	e2:SetTarget(c81006032.tktg)
	e2:SetOperation(c81006032.tkop)
	c:RegisterEffect(e2)
end
function c81006032.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81006032.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81006032,0))
end
function c81006032.ritfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x81c)
end
function c81006032.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81006032.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81040999,0x81c,0x4011,0,0,9,RACE_WARRIOR,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81006032.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,81040999,0x81c,0x4011,0,0,9,RACE_WARRIOR,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,81040999)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
