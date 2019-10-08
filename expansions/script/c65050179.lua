--丰收的甜秋魔杖
function c65050179.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050179)
	e1:SetCondition(c65050179.condition)
	e1:SetTarget(c65050179.target)
	e1:SetOperation(c65050179.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,65050180)
	e2:SetCondition(c65050179.atkcon)
	e2:SetOperation(c65050179.atkop)
	c:RegisterEffect(e2)
end
function c65050179.atcfil(c)
	return c:IsFaceup() and c:IsAttack(0)
end
function c65050179.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and Duel.GetMatchingGroupCount(c65050179.atcfil,tp,LOCATION_MZONE,0,nil)==Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c65050179.atkofil(c)
	return c:IsFaceup() and c:IsAttackBelow(1999)
end
function c65050179.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	local m=0
	while tc do
		if tc:GetAttack()~=tc:GetBaseAttack() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			m=1
		end
		tc=g:GetNext()
	end
	if m==1 then
		local rg=Duel.GetMatchingGroup(c65050179.atkofil,tp,LOCATION_MZONE,0,nil)
		local rgc=rg:GetFirst()
		while rgc do
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetValue(2000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rgc:RegisterEffect(e2)
			rgc=rg:GetNext()
		end
	end
end
function c65050179.confil(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c65050179.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65050179.confil,tp,LOCATION_MZONE,0,1,nil)
end
function c65050179.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6da8) and c:IsAbleToGrave()
end
function c65050179.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050179.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65050179.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c65050179.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end