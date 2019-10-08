--垂直少女世界
function c81011302.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c81011302.matfilter,nil,nil,aux.NonTuner(Card.IsType,TYPE_RITUAL),1,99)
	c:EnableReviveLimit()
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,81011302)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c81011302.thcost)
	e1:SetTarget(c81011302.thtg)
	e1:SetOperation(c81011302.thop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81011392)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81011302.tgtg)
	e2:SetOperation(c81011302.tgop)
	c:RegisterEffect(e2)
end
function c81011302.matfilter(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsAttack(1550) and c:IsDefense(1050))
end
function c81011302.cfilter(c)
	return c:IsAttack(1550) and c:IsDefense(1050) and c:GetOriginalLevel()>0 and c:IsAbleToGraveAsCost()
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c81011302.filter(c,e,tp)
	local rg=Duel.GetMatchingGroup(c81011302.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local lv=c:GetLevel()
	return lv>0 and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and rg:CheckWithSumEqual(Card.GetLevel,lv,1,99)
end
function c81011302.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c81011302.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c81011302.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c81011302.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local lvt={}
	local pc=1
	for i=1,12 do
		if g:IsExists(c81011302.thfilter,1,nil,i) then lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg=Duel.GetMatchingGroup(c81011302.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99)
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81011302.thfilter(c,lv)
	return c:IsLevel(lv) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c81011302.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81011302.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81011302.tgfilter(c)
	return c:IsAttack(1550) and c:IsDefense(1050) and c:IsAbleToGrave()
end
function c81011302.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81011302.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81011302.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81011302.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
