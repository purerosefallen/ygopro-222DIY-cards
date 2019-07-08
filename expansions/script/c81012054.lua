--害羞女仆·理子
function c81012054.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81012054.mfilter,2)
	c:EnableReviveLimit()
	--spsummon
	local e0=aux.AddRitualProcEqual2(c,c81012054.filter,LOCATION_REMOVED,nil,c81012054.psfilter)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCode(0)
	e0:SetCountLimit(1,81012054)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCost(c81012054.cost)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81012954)
	e2:SetCondition(c81012054.spcon)
	e2:SetTarget(c81012054.sptg)
	e2:SetOperation(c81012054.spop)
	c:RegisterEffect(e2)
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c81012054.mfilter(c)
	return c:IsLinkType(TYPE_PENDULUM) and c:IsLinkRace(RACE_PYRO)
end
function c81012054.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)
end
function c81012054.psfilter(c,e,tp)
	return c~=e:GetHandler()
end
function c81012054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c81012054.spcfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c81012054.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81012054.spcfilter,1,nil,tp)
end
function c81012054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81012054.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
