--奇妙仙灵 森小翼
function c65050197.initial_effect(c)
	 c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050197)
	e1:SetCondition(c65050197.con1)
	e1:SetTarget(c65050197.tg)
	e1:SetOperation(c65050197.op)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCondition(c65050197.con2)
	c:RegisterEffect(e0)
	--ritual level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_RITUAL_LEVEL)
	e2:SetCondition(c65050197.rcon)
	e2:SetValue(c65050197.rlevel)
	c:RegisterEffect(e2)
end
function c65050197.rcon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE)
end
function c65050197.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x9da8) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end

function c65050197.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050197.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050197.tgfil(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(6) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>1
end
function c65050197.thfil(c)
	return c:IsSetCard(0x9da8) and c:IsAbleToHand()
end
function c65050197.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050197.tgfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c65050197.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(c65050197.thfil,tp,LOCATION_GRAVE,0,2,nil) end
	local g=Duel.SelectTarget(tp,c65050197.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end
function c65050197.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65050197.thfil,tp,LOCATION_GRAVE,0,2,nil) then
		local g=Duel.SelectMatchingCard(tp,c65050197.thfil,tp,LOCATION_GRAVE,0,2,2,nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end