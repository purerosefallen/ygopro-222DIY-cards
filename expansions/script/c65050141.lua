--闪耀侍者严格培训
function c65050141.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050141+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050141.target)
	e1:SetOperation(c65050141.activate)
	c:RegisterEffect(e1)
end
function c65050141.filter(c)
	return c:IsSetCard(0x5da8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65050141.filter2(c)
	return c:IsSetCard(0x5da8) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c65050141.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050141.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c65050141.cfil2(c)
	return c:IsSetCard(0x5da8) and c:IsFaceup() and c:IsAttackAbove(2000)
end
function c65050141.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65050141.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c65050141.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050141.cfil2,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65050141,0)) then
			local g2=Duel.SelectMatchingCard(tp,c65050141.filter2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g2,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
