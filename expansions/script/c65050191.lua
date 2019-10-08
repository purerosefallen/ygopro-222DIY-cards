--奇妙仙灵 花团
function c65050191.initial_effect(c)
	--onfield
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65050191)
	e1:SetCondition(c65050191.con1)
	e1:SetTarget(c65050191.tg1)
	e1:SetOperation(c65050191.op1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,65050192)
	e2:SetCondition(c65050191.con2)
	e2:SetTarget(c65050191.tg2)
	e2:SetOperation(c65050191.op2)
	c:RegisterEffect(e2)
	local e0=e2:Clone()
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
end
function c65050191.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x9da8) and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c65050191.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65050191.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end


function c65050191.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x9da8) and not eg:IsContains(e:GetHandler())
end
function c65050191.tgfil(c)
	return c:IsSetCard(0x9da8) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c65050191.tgthfil,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c65050191.tgthfil(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c65050191.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050191.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050191.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65050191.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	local code=g:GetFirst():GetCode()
	if g and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local g2=Duel.SelectMatchingCard(tp,c65050191.tgthfil,tp,LOCATION_DECK,0,1,1,nil,code)
		Duel.SendtoHand(g2,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end