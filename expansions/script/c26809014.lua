--花火倒影
function c26809014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26809014+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26809014.condition)
	e1:SetTarget(c26809014.target)
	e1:SetOperation(c26809014.activate)
	c:RegisterEffect(e1)
end
function c26809014.filter(c)
	return c:IsType(TYPE_TOKEN) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c26809014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26809014.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c26809014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c26809014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.IsEnvironment(81010004) then
			Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
