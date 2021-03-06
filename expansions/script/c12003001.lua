--水歌 重奏的senya
function c12003001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12003001,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12003001)
	e1:SetTarget(c12003001.target)
	e1:SetOperation(c12003001.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12003001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,12003101)
	e3:SetCost(c12003001.cost)
	e3:SetTarget(c12003001.tg)
	e3:SetOperation(c12003001.op)
	c:RegisterEffect(e3)
end
function c12003001.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SEASERPENT) and not c:IsCode(12003001) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c12003001.spfilter(c,e,tp)
	return c:IsSetCard(0xfb8) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12003001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12003001.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c12003001.filter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c12003001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12003001.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c12003001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c12003001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
function c12003001.costfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsRace(RACE_SEASERPENT) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c12003001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c12003001.costfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c12003001.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c12003001.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12003001.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end