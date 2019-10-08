--黯黑目光
function c11200087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCountLimit(1,11200087)
	e1:SetCondition(c11200087.con)
	e1:SetTarget(c11200087.target)
	e1:SetOperation(c11200087.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c11200087.descon)
	e2:SetOperation(c11200087.desop)
	c:RegisterEffect(e2)
	--act in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(c11200087.actcon)
	c:RegisterEffect(e3)
end
function c11200087.nfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_RITUAL) or c:IsType(TYPE_FUSION)) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c11200087.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11200087.nfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11200087.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c11200087.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c11200087.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c11200087.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c11200087.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c11200087.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(c11200087.ctval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(e)
		e1:SetCondition(c11200087.con)
		tc:RegisterEffect(e1,true)
		--cannot attack, trigger
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(aux.ctg)
		c:RegisterEffect(e2)
	end
end
function c11200087.con(e)
	local c=e:GetOwner()
	local h=e:GetHandler()
	local te=e:GetLabelObject()
	return c:IsHasCardTarget(h) and not h:IsImmuneToEffect(te)
end
function c11200087.ctval(e,c)
	return e:GetOwnerPlayer()
end
function c11200087.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c11200087.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c11200087.actcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil,11200103) or Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil,11200104)
end
