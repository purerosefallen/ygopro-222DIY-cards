--秋叶原探秘
function c26807016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26807016+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c26807016.condition)
	e1:SetCost(c26807016.cost)
	e1:SetTarget(c26807016.target)
	e1:SetOperation(c26807016.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(26807016,ACTIVITY_SUMMON,c26807016.counterfilter)
	Duel.AddCustomActivityCounter(26807016,ACTIVITY_SPSUMMON,c26807016.counterfilter)
	Duel.AddCustomActivityCounter(26807016,ACTIVITY_FLIPSUMMON,c26807016.counterfilter) 
end
function c26807016.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(81010004)
end
function c26807016.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c26807016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(26807016,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(26807016,tp,ACTIVITY_SPSUMMON)==0 
		and Duel.GetCustomActivityCount(26807016,tp,ACTIVITY_FLIPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c26807016.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c26807016.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c26807016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81010005,0,0x4011,800,800,3,RACE_ROCK,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c26807016.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81010005,0,0x4011,800,800,3,RACE_ROCK,ATTRIBUTE_WIND) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,81010005)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
