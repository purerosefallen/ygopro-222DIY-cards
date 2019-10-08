--奇妙仙灵的展翼升华
function c65050212.initial_effect(c)
	aux.AddRitualProcEqual2(c,c65050212.ritual_filter)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,65050212)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c65050212.target)
	e1:SetOperation(c65050212.activate)
	c:RegisterEffect(e1)
end
function c65050212.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x9da8) 
end
function c65050212.filter(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65050212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050212.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050212.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65050212.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end