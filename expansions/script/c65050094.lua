--沁恋甜心 守候之细雪
function c65050094.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050094+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050094.target)
	e1:SetOperation(c65050094.activate)
	c:RegisterEffect(e1)
end
function c65050094.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcda2) and c:IsAbleToGrave()
end
function c65050094.tgfil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcda2) and c:IsAbleToGrave()
end
function c65050094.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050094.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050094.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c65050094.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c65050094.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c65050094.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
