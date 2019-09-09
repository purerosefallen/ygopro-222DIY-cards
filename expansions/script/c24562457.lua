--毒行天下
function c24562457.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c24562457.reptg)
	e1:SetValue(c24562457.repval)
	e1:SetOperation(c24562457.repop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c24562457.e2cost)
	e2:SetTarget(c24562457.sptg)
	e2:SetOperation(c24562457.spop)
	c:RegisterEffect(e2)
end
--e1
function c24562457.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9390) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c24562457.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c24562457.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c24562457.repval(e,c)
	return c24562457.repfilter(c,e:GetHandlerPlayer())
end
function c24562457.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
--e2
function c24562457.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9390) and c:IsAbleToRemoveAsCost()
end
function c24562457.cfilter1(c,cg,tp)
	return cg:IsExists(c24562457.cfilter2,1,c,c,tp)
end
function c24562457.cfilter2(c,mc,tp)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c24562457.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c24562457.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return cg:IsExists(c24562457.cfilter1,1,nil,cg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=cg:FilterSelect(tp,c24562457.cfilter1,1,1,nil,cg,tp)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=cg:FilterSelect(tp,c24562457.cfilter2,1,1,tc,tc,tp)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c24562457.spfil(c,e,tp)
	return c:IsSetCard(0x9390) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c24562457.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562457.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24562457.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c24562457.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,123,tp,tp,true,false,POS_FACEUP)
	end
end