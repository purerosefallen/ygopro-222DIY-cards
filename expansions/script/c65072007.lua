--渺奏迷景曲-凝望至高
function c65072007.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65072007+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65072007.target)
	e1:SetOperation(c65072007.activate)
	c:RegisterEffect(e1)
end
c65072007.card_code_list={65072000}

function c65072007.filter(c)
	return aux.IsCodeListed(c,65072000) and c:IsAbleToHand()
end
function c65072007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65072007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(11,0,aux.Stringid(65072007,0))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65072007.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65072007.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		--actlimit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(c65072007.actlimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c65072007.actlimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_SPELL) and te:GetHandler():IsType(TYPE_FIELD)
end
