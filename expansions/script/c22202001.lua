--子虚之罠
function c22202001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22202001.target)
	e1:SetOperation(c22202001.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22202001.handcon)
	c:RegisterEffect(e2)
end
function c22202001.filter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c22202001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local a=Duel.GetMatchingGroupCount(c22202001.filter,tp,0,LOCATION_SZONE,nil)
	if chk==0 then return a>0 end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c22202001.chainlimit)
	end
end
function c22202001.chainlimit(e,rp,tp)
	return not (e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsType(TYPE_TRAP))
end
function c22202001.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
	if g1:GetCount()<1 then return end
	Duel.ConfirmCards(tp,g1)
	local g=g1:Filter(Card.IsType,nil,TYPE_TRAP)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(0,1)
			e1:SetValue(c22202001.aclimit)
			e1:SetLabel(code)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			tc=g:GetNext()
		end
		if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22202001,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			if dg:GetCount()>0 then Duel.Destroy(dg,REASON_EFFECT) end
		end
	else
		Duel.Draw(1-tp,2,REASON_EFFECT)
	end
end
function c22202001.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c22202001.handcon(e)
	local tp=e:GetHandlerPlayer()
	for i=0,4 do
		if Duel.GetFieldCard(tp,LOCATION_SZONE,i) then return false end
	end
	return true
end