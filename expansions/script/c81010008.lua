--放送事故
function c81010008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c81010008.condition)
	e1:SetTarget(c81010008.target)
	e1:SetOperation(c81010008.activate)
	c:RegisterEffect(e1)
end
function c81010008.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c81010008.rmfilter(c)
	return c:IsAbleToRemove() and c~=Duel.GetAttacker()
end
function c81010008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c81010008.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,at) end
	local g=Duel.GetMatchingGroup(c81010008.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,at)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81010008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81010008.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,at)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
