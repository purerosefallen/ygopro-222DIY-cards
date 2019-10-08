--蜜食彩虹拼盘 沁心
function c65050168.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65050168.ffilter,3,true)
	--ChangeAttack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65050168.contcon)
	e1:SetOperation(c65050168.contop)
	c:RegisterEffect(e1)
	 --chain
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c65050168.con)
	e2:SetTarget(c65050168.tg)
	e2:SetOperation(c65050168.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e3)
	--chain2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c65050168.con2)
	e4:SetTarget(c65050168.tg2)
	e4:SetOperation(c65050168.op2)
	c:RegisterEffect(e4)
end
function c65050168.ffilter(c)
	return c:IsFusionSetCard(0x6da8) and c:IsAttackAbove(2000)
end
function c65050168.atkcfil(c,tp)
	return c:GetSummonPlayer()~=tp and c:IsFaceup() and c:IsAttackAbove(2000)
end
function c65050168.contcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050168.atkcfil,1,nil,tp)
end
function c65050168.contop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65050168.atkcfil,nil,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

function c65050168.confil(c)
	return c:IsAttack(0) and c:IsFaceup()
end
function c65050168.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050168.confil,1,nil)
end
function c65050168.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c65050168.confil,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c65050168.op(e,tp,eg,ep,ev,re,r,rp)
   local g=eg:Filter(c65050168.confil,nil)
   if g:GetCount()>0 then
	   Duel.Destroy(g,REASON_EFFECT)
   end
end

function c65050168.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttack(0) and Duel.IsChainNegatable(ev)
end
function c65050168.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
end
function c65050168.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end