--琪亚娜的邂逅
function c75646906.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,75646906)
	e2:SetCost(c75646906.cost)
	e2:SetTarget(c75646906.target)
	e2:SetOperation(c75646906.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,5646906)
	e3:SetCondition(c75646906.con)
	e3:SetTarget(c75646906.tg)
	e3:SetOperation(c75646906.op)
	c:RegisterEffect(e3)
end
function c75646906.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c75646906.cfilter(c,e,tp)
	if c:IsLocation(LOCATION_MZONE) then return c:IsFaceup() and c:IsSetCard(0xc2c1) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToGraveAsCost()
			and Duel.IsExistingMatchingCard(c75646906.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode()) end
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646911,tp) and Duel.IsExistingMatchingCard(c75646906.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c75646906.thfilter(c,e,tp,code)
	return not c:IsCode(code) and c:IsSetCard(0xc2c1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646906.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c75646906.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646906.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	e:SetValue(tc:GetCode())
	local te=tc:IsHasEffect(75646911,tp)
	if te then
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	else
		Duel.SendtoGrave(g,REASON_COST)
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c75646906.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75646906.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetValue())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75646906.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7f0)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c75646906.filter1(c)
	return c:IsSetCard(0xc2c1) and c:IsAbleToHand() and not c:IsCode(75646906)
end
function c75646906.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c75646906.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646906.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c75646906.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c75646906.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end