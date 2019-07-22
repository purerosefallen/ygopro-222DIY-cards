--童话故事·岛村卯月
function c81007037.initial_effect(c)
	aux.EnableDualAttribute(c)
		--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81007037,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1,81007037)
	e3:SetCondition(c81007037.atkcon)
	e3:SetCost(c81007037.atkcost)
	e3:SetTarget(c81007037.atktg)
	e3:SetOperation(c81007037.atkop)
	c:RegisterEffect(e3)
end
function c81007037.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and aux.IsDualState(e)
end
function c81007037.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c81007037.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL)
end
function c81007037.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81007037.atkfilter(chkc) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 and
		Duel.IsExistingTarget(c81007037.atkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81007037.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81007037.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)*500
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
