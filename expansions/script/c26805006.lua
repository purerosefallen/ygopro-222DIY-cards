--月刊CLIMAX
function c26805006.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c26805006.activate)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,26805006)
	e3:SetCondition(c26805006.drcon)
	e3:SetCost(c26805006.drcost)
	e3:SetTarget(c26805006.drtg)
	e3:SetOperation(c26805006.drop)
	c:RegisterEffect(e3)
end
function c26805006.filter(c,tp)
	return c:IsCode(81010004) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26805006.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c26805006.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(26805006,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26805006.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c26805006.cfilter(c)
	return c:IsCode(81010005) and c:IsFaceup()
end
function c26805006.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26805006.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c26805006.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsDiscardable()
end
function c26805006.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26805006.drfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c26805006.drfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c26805006.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c26805006.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
