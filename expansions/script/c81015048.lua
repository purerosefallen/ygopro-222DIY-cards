--北上丽花的凝视
require("expansions/script/c81000000")
function c81015048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81015048)
	e1:SetCondition(c81015048.condition)
	e1:SetTarget(c81015048.target)
	e1:SetOperation(c81015048.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,81015948)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(Tenka.ReikaCon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81015048.immtg)
	e2:SetOperation(c81015048.immop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(Tenka.ReikaCon)
	c:RegisterEffect(e3)
end
function c81015048.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81a)
end
function c81015048.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.IsExistingMatchingCard(c81015048.cfilter,tp,LOCATION_MZONE,0,1,nil) and rc:IsOnField() and rc:IsControler(1-tp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c81015048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c81015048.activate(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c81015048.immtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81015048.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81015048.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81015048.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81015048.immop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c81015048.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c81015048.efilter(e,te)
	return te:GetOwner()~=e:GetHandler()
end
