--+猛毒性 淤流
function c24562482.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24562483,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9390),1,false,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562482,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,24562446)
	e1:SetCondition(c24562482.e1con)
	e1:SetTarget(c24562482.e1tg)
	e1:SetOperation(c24562482.e1op)
	c:RegisterEffect(e1)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c24562482.splimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24562482,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,24562461)
	e4:SetCondition(c24562482.e4con)
	e4:SetTarget(c24562482.e4tg)
	e4:SetOperation(c24562482.e4op)
	c:RegisterEffect(e4)
end
function c24562482.d2fil(c,abab1)
	return c:IsSetCard(0x9390) and c:IsType(TYPE_MONSTER) and c:IsAttackBelow(abab1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24562482.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local abab1=ev
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c24562482.d2fil,tp,LOCATION_DECK,0,1,nil,abab1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24562482.e4op(e,tp,eg,ep,ev,re,r,rp)
	local abab1=ev
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c24562482.d2fil,tp,LOCATION_EXTRA,0,1,1,nil,abab1)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c24562482.e4con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
--
function c24562482.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x9390)
end
function c24562482.e1con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c24562482.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c24562482.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e)then return end
	if not Duel.MoveToField(c,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)--(-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24562482,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c24562482.damcon)
	e3:SetOperation(c24562482.damop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	c:RegisterFlagEffect(24562482,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(24562482,1))
	c:RegisterFlagEffect(24562483,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(24562482,2))
end
function c24562482.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x9390)
end
function c24562482.cfilter2(c,tp)
	return c:GetSummonPlayer()==tp
end
function c24562482.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24562482.cfilter1,tp,0,LOCATION_MZONE,1,nil)
		and eg:IsExists(c24562482.cfilter2,1,nil,tp)
end
function c24562482.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,24562482)
	Duel.Damage(tp,250,REASON_EFFECT)
end