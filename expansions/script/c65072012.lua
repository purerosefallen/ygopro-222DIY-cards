--渺奏迷景曲-钟爱一生
function c65072012.initial_effect(c)
	--give effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65072012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65072012.tg)
	e1:SetOperation(c65072012.op)
	c:RegisterEffect(e1)
end
c65072012.card_code_list={65072000}
function c65072012.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsCode(65071999) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,65071999) end
	Duel.Hint(11,0,aux.Stringid(65072012,0))
	local g=Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,65071999)
end
function c65072012.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(tc)
	e1:SetDescription(aux.Stringid(65072012,1))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetCondition(c65072012.condition)
	e1:SetCost(c65072012.cost)
	e1:SetTarget(c65072012.target)
	e1:SetOperation(c65072012.operation)
	tc:RegisterEffect(e1,true)
	tc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65072012,1))
end
function c65072012.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsType(TYPE_FIELD) and Duel.IsChainNegatable(ev)
end
function c65072012.costfil(c)
	return c:IsType(TYPE_FIELD) and aux.IsCodeListed(c,65072000) and c:IsAbleToDeckAsCost()
end
function c65072012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65072012.costfil,tp,LOCATION_GRAVE,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,c65072012.costfil,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c65072012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65072012.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetCode(EFFECT_CANNOT_TRIGGER)
		e0:SetRange(LOCATION_FZONE)
		e0:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		if tc:IsType(TYPE_NORMAL) then
		--become effect
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetValue(TYPE_EFFECT)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e4,true)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_REMOVE_TYPE)
	e5:SetValue(TYPE_NORMAL)
	token:RegisterEffect(e5,true)
		end
	end
end