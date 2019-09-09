--猛毒性 井守
function c24562460.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562460,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,24562460)
	e1:SetCondition(c24562460.spcon)
	e1:SetTarget(c24562460.sptg)
	e1:SetOperation(c24562460.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562460,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,24562455)
	e2:SetCondition(c24562460.tgcon)
	e2:SetTarget(c24562460.tgtg)
	e2:SetOperation(c24562460.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c24562460.tgconfil(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c24562460.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetHandler():GetColumnGroup()
	if cg:IsExists(c24562460.tgconfil,1,nil) then return false
	else return true
	end
end
function c24562460.tgfilter(c)
	return c:IsSetCard(0x9390) and not c:IsCode(24562460) and c:IsAbleToRemove()
end
function c24562460.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562460.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c24562460.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562460.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	e1:SetCondition(c24562460.thcon)
	e1:SetOperation(c24562460.thop)
	e1:SetLabel(1)
	tg:RegisterEffect(e1)
end
function c24562460.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c24562460.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else e:SetLabel(1) end
end
---
function c24562460.cfilter(c,tp)
	return c:IsSetCard(0x9390) and c:IsType(TYPE_MONSTER) and not c:IsCode(24562460) and c:IsControler(tp)
end
function c24562460.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c24562460.cfilter,1,nil,tp)
end
function c24562460.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c24562460.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end