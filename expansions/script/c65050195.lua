--奇妙仙灵 贵小翼
function c65050195.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050195)
	e1:SetCondition(c65050195.con1)
	e1:SetTarget(c65050195.tg)
	e1:SetOperation(c65050195.op)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCondition(c65050195.con2)
	c:RegisterEffect(e0)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,65050196)
	e2:SetCondition(c65050195.condition)
	e2:SetTarget(c65050195.target)
	e2:SetOperation(c65050195.activate)
	c:RegisterEffect(e2)
end
function c65050195.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050195.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050195.tgfil(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(6) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>1
end
function c65050195.thfil1(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65050195.thfil2(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c65050195.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050195.tgfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c65050195.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c65050195.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050195.thfil2,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65050195.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c65050195.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65050195.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050195.thfil2,tp,LOCATION_DECK,0,1,nil) then
		local g1=Duel.SelectMatchingCard(tp,c65050195.thfil1,tp,LOCATION_DECK,0,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,c65050195.thfil2,tp,LOCATION_DECK,0,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end

function c65050195.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not (e:GetHandler():IsReason(REASON_EFFECT) and re:GetHandler()==e:GetHandler())
end
function c65050195.filter(c,e,tp)
	return c:IsSetCard(0x9da8) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65050195.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050195.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050195.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65050195.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
