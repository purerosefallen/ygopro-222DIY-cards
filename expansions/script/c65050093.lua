--沁恋甜心 注视之繁樱
function c65050093.initial_effect(c)
	  --summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050093+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050093.sumtg)
	e1:SetOperation(c65050093.sumop)
	c:RegisterEffect(e1)
end
function c65050093.filter(c,e,tp)
	return c:IsSetCard(0xcda2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c65050093.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c65050093.filter2(c,code)
	return c:IsSetCard(0xcda2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end
function c65050093.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050093.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050093.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end   
	local g=Duel.SelectMatchingCard(tp,c65050093.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local code=g:GetFirst():GetCode()
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c65050093.filter2,tp,LOCATION_DECK,0,1,nil,code) then
			Duel.BreakEffect()
			local tg=Duel.SelectMatchingCard(tp,c65050093.filter2,tp,LOCATION_DECK,0,1,1,nil,code)
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end