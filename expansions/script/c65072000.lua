--渺奏迷景-仙境
function c65072000.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072000+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65072000.tg)
	e1:SetOperation(c65072000.op)
	c:RegisterEffect(e1)
end
c65072000.card_code_list={65072000}
function c65072000.fil1(c)
	return aux.IsCodeListed(c,65072000) and not c:IsForbidden() and c:IsType(TYPE_FIELD)
end
function c65072000.fil2(c)
	return c:IsSetCard(0xcda7) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c65072000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65072000.fil1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_COST) and Duel.IsExistingMatchingCard(c65072000.fil2,tp,LOCATION_DECK,0,1,nil) 
	if chk==0 then return b1 or b2 end
	local m=8
	if b1 and b2 then
		m=Duel.SelectOption(tp,aux.Stringid(65072000,0),aux.Stringid(65072000,1))
	elseif b1 then
		m=0
	elseif b2 then
		m=1
	end
	e:SetLabel(m)
	if m==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c65072000.op(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	local b1=Duel.IsExistingMatchingCard(c65072000.fil1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_COST) and Duel.IsExistingMatchingCard(c65072000.fil2,tp,LOCATION_DECK,0,1,nil)
	if m==0 and b1 then
		local g1=Duel.SelectMatchingCard(tp,c65072000.fil1,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g1:GetFirst()
		local code=tc:GetCode()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(11,0,aux.Stringid(code,0))
	elseif m==1 and b2 then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,e:GetHandler())
		local g2=Duel.SelectMatchingCard(tp,c65072000.fil2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g2,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end