--奇妙仙灵的净翼献礼
function c65050214.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050214+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050214.tg)
	e1:SetOperation(c65050214.op)
	c:RegisterEffect(e1)
end
function c65050214.refil1(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c65050214.refil2(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function c65050214.spfil(c,e,tp)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c65050214.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050214.refil1,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c65050214.refil2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c65050214.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65050214.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,c65050214.refil1,tp,LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c65050214.refil2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()==2 and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)==2  and Duel.IsExistingMatchingCard(c65050214.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 then
		local sg=Duel.SelectMatchingCard(tp,c65050214.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end