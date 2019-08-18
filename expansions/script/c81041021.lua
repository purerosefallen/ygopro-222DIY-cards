--随风而来的再遇
function c81041021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81041021+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81041021.cost)
	e1:SetTarget(c81041021.target)
	e1:SetOperation(c81041021.activate)
	c:RegisterEffect(e1)
end
function c81041021.cfilter(c,tp)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsType(TYPE_PENDULUM) and c:GetLevel()<c:GetOriginalLevel() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c81041021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c81041021.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c81041021.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c81041021.filter(c,e,tp)
	return c:IsAttack(1550) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81041021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81041021.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81041021.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c81041021.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
