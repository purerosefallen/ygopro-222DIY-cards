--国见洸太郎 & 姬野星奏
function c81041015.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81041015.mfilter,2)
	c:EnableReviveLimit()
	--atk up
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c81041015.atkcon)
	e0:SetValue(c81041015.atkval)
	c:RegisterEffect(e0)
	--To hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81041015)
	e1:SetTarget(c81041015.thtg)
	e1:SetOperation(c81041015.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,81041915)
	e2:SetCondition(c81041015.spcon)
	e2:SetTarget(c81041015.sptg)
	e2:SetOperation(c81041015.spop)
	c:RegisterEffect(e2)
end
function c81041015.mfilter(c)
	return c:IsAttack(1550) and c:IsDefense(1050)
end
function c81041015.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c81041015.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:GetLevel()>0
end
function c81041015.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(c81041015.atkfilter,nil)
	return lg:GetSum(Card.GetLevel)*300
end
function c81041015.thfilter(c)
	return c:IsCode(81041005) and c:IsFaceup() and c:IsAbleToHand()
end
function c81041015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81041015.thfilter(chkc) end
	local h=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return Duel.IsExistingTarget(c81041015.thfilter,tp,LOCATION_REMOVED,0,1,nil) and h:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81041015.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,h,1,0,0)
end
function c81041015.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local h=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
		if h:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=h:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c81041015.spfilter(c,tp)
	return c:IsControler(tp) and c:IsAttack(1550) and c:IsDefense(1050) and c:IsFaceup() and c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_RITUAL) or c:IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c81041015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81041015.spfilter,1,nil,tp)
end
function c81041015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81041015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
