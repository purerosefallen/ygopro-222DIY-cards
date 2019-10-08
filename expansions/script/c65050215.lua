--奇妙仙灵的柔翼软云
function c65050215.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050215+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050215.target)
	e1:SetOperation(c65050215.activate)
	c:RegisterEffect(e1)
end
function c65050215.filter(c,e,tp)
	return c:IsSetCard(0x9da8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65050215.fil1(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c65050215.fil2(c,e,tp)
	return c:IsSetCard(0x9da8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65050215.fil3(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c65050215.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(c65050215.fil1,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65050215.fil2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>1
	local b3=Duel.IsExistingMatchingCard(c65050215.fil3,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c65050215.filter(chkc,e,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c65050215.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and (b1 or b2 or b3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c65050215.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65050215.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local b1=Duel.IsExistingMatchingCard(c65050215.fil1,tp,LOCATION_HAND,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c65050215.fil2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
		local b3=Duel.IsExistingMatchingCard(c65050215.fil3,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		local op=9
		if b1 and b2 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(65050215,0),aux.Stringid(65050215,1),aux.Stringid(65050215,2))
		elseif b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(65050215,0),aux.Stringid(65050215,1))
		elseif b1 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(65050215,0),aux.Stringid(65050215,2))
			if op==1 then op=2 end
		elseif b2 and b3 then
			op=Duel.SelectOption(tp,aux.Stringid(65050215,1),aux.Stringid(65050215,2))+1
		elseif b1 then
			op=0
		elseif b2 then
			op=1
		elseif b3 then
			op=2
		end
		if op==0 then
			Duel.BreakEffect()
			local tgg=Duel.SelectMatchingCard(tp,c65050215.fil1,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoGrave(tgg,REASON_EFFECT)
		elseif op==1 then
			Duel.BreakEffect()
			local spg=Duel.SelectMatchingCard(tp,c65050215.fil2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		elseif op==2 then
			Duel.BreakEffect()
			local stg=Duel.SelectMatchingCard(tp,c65050215.fil3,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SSet(tp,stg:GetFirst())
			Duel.ConfirmCards(1-tp,stg)
		end
	end
end