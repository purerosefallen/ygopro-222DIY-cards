--向着终将绽放星光的未来
function c75646211.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646211+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75646211.target)
	e1:SetOperation(c75646211.activate)
	c:RegisterEffect(e1)
end
function c75646211.filter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2c0) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c75646211.filter2,tp,LOCATION_DECK,0,1,nil)
end
function c75646211.filter2(c,mc)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x2c0) and c:IsAbleToHand()
end
function c75646211.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646211.filter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c75646211.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646211.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(c75646211.filter2,tp,LOCATION_DECK,0,nil)
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	Duel.BreakEffect()
	Duel.Draw(1-tp,2,REASON_EFFECT)
end
