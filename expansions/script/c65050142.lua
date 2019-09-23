--闪耀侍者早晨陪伴
function c65050142.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050142+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050142.target)
	e1:SetOperation(c65050142.activate)
	c:RegisterEffect(e1)
end
function c65050142.tgfil(c,tp)
	return c:IsSetCard(0x5da8) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and Duel.IsExistingMatchingCard(c65050142.thfil,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
end
function c65050142.thfil(c,lv)
	return c:IsSetCard(0x5da8) and c:IsLevel(lv) and c:IsAbleToHand()
end
function c65050142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c65050142.tgfil,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SelectTarget(tp,c65050142.tgfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050142.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetLevel()
		local g=Duel.SelectMatchingCard(tp,c65050142.thfil,tp,LOCATION_DECK,0,1,1,nil,lv)
		if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65050142,0)) then
				Duel.DiscardHand(tp,Card.IsAbleToGrave,1,1,REASON_EFFECT,nil)
			end
		end
	end
end
