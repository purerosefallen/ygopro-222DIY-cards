--闪耀侍者秘蜜奖赏
function c65050147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050147+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65050147.con)
	e1:SetTarget(c65050147.target)
	e1:SetOperation(c65050147.activate)
	c:RegisterEffect(e1)
end
function c65050147.confil(c)
	return c:IsFaceup() and c:IsSetCard(0x5da8) and c:IsLevelAbove(6)
end
function c65050147.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65050147.confil,tp,LOCATION_MZONE,0,1,nil)
end
function c65050147.filter(c)
	return c:IsSetCard(0x5da8) and c:IsAbleToHand()
end
function c65050147.filter2(c,tp)
	return c:IsSetCard(0x5da8) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c65050147.fil3,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c65050147.fil3(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c65050147.nexfil(c)
	return c:IsFaceup() and c:IsSetCard(0x5da8) and c:IsLevel(9)
end
function c65050147.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050147.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050147.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65050147.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c65050147.nexfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c65050147.filter2,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(65050147,0)) then
			local g2=Duel.SelectMatchingCard(tp,c65050147.filter2,tp,LOCATION_DECK,0,1,1,nil,tp)
			if Duel.SendtoGrave(g2,REASON_EFFECT)~=0 then
				local code=g2:GetFirst():GetCode()
				local tc=Duel.GetFirstMatchingCard(c65050147.fil3,tp,LOCATION_DECK,0,nil,code)
				Duel.SendtoHand(tc,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
