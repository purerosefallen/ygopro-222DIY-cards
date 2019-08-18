--夏日激战·西城树里
function c26805009.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,26805009)
	e1:SetCondition(c26805009.spcon)
	e1:SetValue(c26805009.spval)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCountLimit(1,26805909)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c26805009.thcon)
	e3:SetTarget(c26805009.thtg)
	e3:SetOperation(c26805009.thop)
	c:RegisterEffect(e3)
end
function c26805009.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_LINK)
end
function c26805009.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c26805009.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c26805009.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c26805009.checkzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c26805009.spval(e,c)
	local tp=c:GetControler()
	local zone=c26805009.checkzone(tp)
	return 0,zone
end
function c26805009.dfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:GetPreviousControler()==tp
end
function c26805009.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26805009.dfilter,1,nil,tp)
end
function c26805009.thfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c26805009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26805009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26805009.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26805009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
