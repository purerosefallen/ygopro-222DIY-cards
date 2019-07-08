--天台花园·高山纱代子
function c81017015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)
	c:EnableReviveLimit()
	--destroy all
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81017015,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c81017015.destg)
	e1:SetOperation(c81017015.desop)
	c:RegisterEffect(e1)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81017015,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81017015)
	e4:SetCondition(c81017015.drcon)
	e4:SetCost(c81017015.cost)
	e4:SetTarget(c81017015.drtg)
	e4:SetOperation(c81017015.drop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(81017015,ACTIVITY_SPSUMMON,c81017015.counterfilter)
end
function c81017015.counterfilter(c)
	return c:IsSetCard(0x819)
end
function c81017015.desfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x819)
end
function c81017015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c81017015.desfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c81017015.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81017015.desfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c81017015.exfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x819)
end
function c81017015.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsExistingMatchingCard(c81017015.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81017015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) and Duel.GetCustomActivityCount(81017015,tp,ACTIVITY_SPSUMMON)==0 end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81017015.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c81017015.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x819)
end
function c81017015.drfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c81017015.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c81017015.drfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c81017015.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c81017015.drfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
