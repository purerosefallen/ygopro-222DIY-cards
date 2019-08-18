--最上静香的温泉纪行
function c81018042.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81018042)
	e1:SetCost(c81018042.cost)
	e1:SetOperation(c81018042.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,81018942)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81018042.cttg)
	e2:SetOperation(c81018042.ctop)
	c:RegisterEffect(e2)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81018042.handcon)
	c:RegisterEffect(e0)
end
function c81018042.cfilter(c)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
end
function c81018042.handcon(e)
	return Duel.IsExistingMatchingCard(c81018042.cfilter,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c81018042.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81018042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1810,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1810,3,REASON_COST)
end
function c81018042.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c81018042.tgfilter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	Duel.RegisterEffect(e2,tp)
end
function c81018042.tgfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x81b) and c:IsLocation(LOCATION_MZONE)
end
function c81018042.sfilter(c)
	return c:IsCanAddCounter(0x1810,1) and c:IsPosition(POS_FACEUP_ATTACK)
end
function c81018042.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c81018042.sfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81018042.sfilter,tp,0,LOCATION_MZONE,1,nil,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81018042.sfilter,tp,0,LOCATION_MZONE,1,1,nil,nil)
end
function c81018042.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x1810,1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c81018042.condition)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_MUST_ATTACK)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(81018042,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function c81018042.condition(e)
	return e:GetHandler():GetCounter(0x1810)>0 and e:GetHandler():GetFlagEffect(81018042)~=0
end
