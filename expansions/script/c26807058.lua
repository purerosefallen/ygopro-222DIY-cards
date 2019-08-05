--雨落心音
function c26807058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26807058+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c26807058.cost)
	e1:SetTarget(c26807058.target)
	e1:SetOperation(c26807058.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(26807058,ACTIVITY_SPSUMMON,c26807058.counterfilter)
end
function c26807058.counterfilter(c)
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c26807058.costfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c26807058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26807058.costfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,nil) and Duel.GetCustomActivityCount(26807058,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26807058.costfilter,tp,LOCATION_EXTRA+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c26807058.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c26807058.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_RITUAL)~=SUMMON_TYPE_RITUAL
end
function c26807058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c26807058.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
