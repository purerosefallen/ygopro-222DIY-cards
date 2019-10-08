--奇妙仙灵 信使
function c65050187.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,65050187)
	e1:SetCondition(c65050187.con1)
	e1:SetTarget(c65050187.tg1)
	e1:SetOperation(c65050187.op1)
	c:RegisterEffect(e1)
	--onfield
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65050188)
	e2:SetCondition(c65050187.con2)
	e2:SetTarget(c65050187.tg2)
	e2:SetOperation(c65050187.op2)
	c:RegisterEffect(e2)
end
function c65050187.confil1(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_MONSTER)
end
function c65050187.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050187.confil1,1,nil) and not eg:IsContains(e:GetHandler())
end
function c65050187.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65050187.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65050187.tgfil(c)
	return c:IsSetCard(0x9da8) and c:IsAbleToGrave()
end
function c65050187.thfil1(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65050187.thfil2(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c65050187.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x9da8) and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c65050187.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050187.tgfil,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c65050187.thfil1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65050187.thfil2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c65050187.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.DiscardHand(tp,c65050187.tgfil,1,1,REASON_EFFECT)~=0 then
		local g1=Duel.SelectMatchingCard(tp,c65050187.thfil1,tp,LOCATION_DECK,0,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,c65050187.thfil2,tp,LOCATION_DECK,0,1,1,nil)
		if g1 and g2 then
			g1:Merge(g2)
			Duel.SendtoHand(g1,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
end