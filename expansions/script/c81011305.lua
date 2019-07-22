--灰姑娘女孩·本田未央
function c81011305.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_TOKEN),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c81011305.value)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c81011305.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c81011305.tkcon)
	e4:SetCost(c81011305.tkcost)
	e4:SetTarget(c81011305.tktg)
	e4:SetOperation(c81011305.tkop)
	c:RegisterEffect(e4)
end
function c81011305.filter(c)
	return c:IsType(TYPE_TOKEN)
end
function c81011305.value(e,c)
	return Duel.GetMatchingGroupCount(c81011305.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*1500
end
function c81011305.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c81011305.cfilter(c,tp)
	return not c:IsType(TYPE_TOKEN)
end
function c81011305.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81011305.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c81011305.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,81011305)==0 end
	Duel.RegisterFlagEffect(tp,81011305,RESET_CHAIN,0,1)
end
function c81011305.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c81011305.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,81009002,0,0x4011,1000,1000,4,RACE_FAIRY,ATTRIBUTE_FIRE,POS_FACEUP_DEFENSE)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,81009002,0,0x4011,1000,1000,4,RACE_FAIRY,ATTRIBUTE_FIRE,POS_FACEUP_DEFENSE,1-tp) 
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local token1=Duel.CreateToken(tp,81009002)
	local token2=Duel.CreateToken(tp,81009002)
	Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SpecialSummonComplete()
end
