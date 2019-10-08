--防卫降临
function c40008734.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40008734)
	e1:SetCost(c40008734.cost)
	e1:SetTarget(c40008734.target)
	e1:SetOperation(c40008734.activate)
	c:RegisterEffect(e1)
end
function c40008734.costfilter(c)
	return (c:IsSetCard(0xf15) or c:IsSetCard(0xf16)) and (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsAbleToGraveAsCost()
end
function c40008734.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008734.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40008734.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c40008734.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c40008734.thfilter(c)
	return c:IsSetCard(0xf15) and c:IsAbleToGrave()
end
function c40008734.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40008734.thfilter),tp,LOCATION_GRAVE,0,nil)
	if (Duel.IsEnvironment(40008726) or Duel.IsEnvironment(40008757)) and g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,40008734)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,nil,REASON_EFFECT)
	end
end

