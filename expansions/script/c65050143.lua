--闪耀侍者新人实践
function c65050143.initial_effect(c)
	 aux.AddRitualProcGreater2(c,c65050143.ritual_filter)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c65050143.condition)
	e1:SetCost(aux.bfgcost)
	e1:SetOperation(c65050143.activate)
	c:RegisterEffect(e1)
end
function c65050143.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x5da8) and c:IsLevelBelow(6)
end
function c65050143.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():CancelToGrave(false)
	end
	local g=Duel.SelectMatchingCard(tp,c65050143.repfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c65050143.repfil(c,e,tp)
	return c:IsSetCard(0x5da8) and c:IsLevel(3) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c65050143.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep==tp 
		and Duel.IsExistingMatchingCard(c65050143.repfil,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
end
function c65050143.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65050143.repop)
	 local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c65050143.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c65050143.splimit(e,c)
	return not c:IsSetCard(0x5da8)
end