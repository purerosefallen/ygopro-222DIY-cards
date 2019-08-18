--如月千早不善言辞
function c26810012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26810012+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c26810012.cost)
	e1:SetTarget(c26810012.target)
	e1:SetOperation(c26810012.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(26810012,ACTIVITY_SUMMON,c26810012.counterfilter)
	Duel.AddCustomActivityCounter(26810012,ACTIVITY_SPSUMMON,c26810012.counterfilter)
	Duel.AddCustomActivityCounter(26810012,ACTIVITY_FLIPSUMMON,c26810012.counterfilter)
end
function c26810012.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c26810012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_WATER) 
		and Duel.GetCustomActivityCount(26810012,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(26810012,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(26810012,tp,ACTIVITY_FLIPSUMMON)==0 end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_WATER)
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c26810012.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c26810012.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c26810012.filter(c)
	return c:IsSetCard(0x601) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c26810012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26810012.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26810012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26810012.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
