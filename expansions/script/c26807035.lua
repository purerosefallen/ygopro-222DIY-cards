--下午茶·星尘
function c26807035.initial_effect(c)
	c:SetUniqueOnField(1,0,26807035)
	--link summon
	aux.AddLinkProcedure(c,c26807035.mfilter,2,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26807035)
	e1:SetCondition(c26807035.spcon)
	e1:SetTarget(c26807035.sptg)
	e1:SetOperation(c26807035.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c26807035.atktg)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
end
function c26807035.mfilter(c)
	return c:IsAttack(2200) and c:IsDefense(600)
end
function c26807035.atktg(e,c)
	return c:IsType(TYPE_LINK) and c~=e:GetHandler()
end
function c26807035.cfilter(c)
	return c:IsFaceup() and c:IsAttack(3200) and c:IsType(TYPE_LINK)
end
function c26807035.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26807035.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c26807035.dfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c26807035.spfilter(c,e,tp)
	return c:IsAttack(2200) and c:IsDefense(600) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c26807035.dfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c26807035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26807035.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26807035.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26807035.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
