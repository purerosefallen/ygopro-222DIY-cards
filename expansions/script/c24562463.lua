--+猛毒性 陟厘
function c24562463.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24562462,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9390),1,false,false)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562463,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,24562453)
	e2:SetCondition(c24562463.atkcon)
	e2:SetTarget(c24562463.target)
	e2:SetOperation(c24562463.activate)
	c:RegisterEffect(e2)
	--damage 0
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562463,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,24562463)
	e1:SetCondition(c24562463.e1con)
	e1:SetTarget(c24562463.e1tg)
	e1:SetOperation(c24562463.e1op)
	c:RegisterEffect(e1)
end
function c24562463.e1con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4
end
function c24562463.rmfil(c,atk2)
	return c:IsAbleToRemove() and c:IsAttackBelow(atk2)
end
function c24562463.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	atk2=c:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c24562463.rmfil,tp,0,LOCATION_ONFIELD,1,nil,atk2) end
	local g=Duel.GetMatchingGroup(c24562463.rmfil,tp,0,LOCATION_ONFIELD,nil,atk2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_ONFIELD)
end
function c24562463.e1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	atk2=c:GetAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c24562463.rmfil,tp,0,LOCATION_ONFIELD,1,1,nil,atk2)
	local tc=g:GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
		end
	end
end
function c24562463.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c24562463.filter(c)
	return c:IsFaceup()
end
function c24562463.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c24562463.filter(chkc) end
	if chk==0 then return c:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c24562463.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local atk=c:GetTextAttack()
		if atk<0 then atk=0 end
		local val=Duel.Damage(tp,atk/2,REASON_EFFECT)
		if val>0 and Duel.GetLP(tp)>0 then
			Duel.Damage(1-tp,val,REASON_EFFECT)
		end
	end
end