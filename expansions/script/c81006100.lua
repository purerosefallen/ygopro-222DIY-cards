--北宫的约定
function c81006100.initial_effect(c)
	aux.AddRitualProcGreater(c,c81006100.ritual_filter)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c81006100.thtg)
	e1:SetOperation(c81006100.thop)
	c:RegisterEffect(e1)
end
function c81006100.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttack(2800) and c:IsDefense(600)
end
function c81006100.thfilter(c)
	return c:IsCode(81006100) and c:IsAbleToHand()
end
function c81006100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81006100.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81006100.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81006100.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
