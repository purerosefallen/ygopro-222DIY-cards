--奇妙仙灵 素净翼
function c65050206.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x9da8),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050206)
	e1:SetCondition(c65050206.con1)
	e1:SetTarget(c65050206.tg)
	e1:SetOperation(c65050206.op)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCondition(c65050206.con2)
	c:RegisterEffect(e0)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,65050207)
	e2:SetCondition(c65050206.condition)
	e2:SetTarget(c65050206.target)
	e2:SetOperation(c65050206.activate)
	c:RegisterEffect(e2)
end
function c65050206.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050206.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050206.tgfil(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(6) and c:IsAbleToGrave() 
end
function c65050206.spfil(c,e,tp)
	return c:IsSetCard(0x9da8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(6)
end
function c65050206.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050206.tgfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c65050206.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c65050206.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	local g=Duel.SelectTarget(tp,c65050206.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050206.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c65050206.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

function c65050206.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not (e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()==e:GetHandler())
end
function c65050206.filter(c)
	return c:IsSetCard(0x9da8) and c:IsAbleToHand()
end
function c65050206.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050206.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65050206.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65050206.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
