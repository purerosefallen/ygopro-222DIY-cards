--奇妙仙灵 幻梦
function c65050183.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,65050183)
	e1:SetCondition(c65050183.con1)
	e1:SetTarget(c65050183.tg1)
	e1:SetOperation(c65050183.op1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,65050184)
	e2:SetCondition(c65050183.con2)
	e2:SetTarget(c65050183.tg2)
	e2:SetOperation(c65050183.op2)
	c:RegisterEffect(e2)
	local e0=e2:Clone()
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
end
function c65050183.confil1(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_MONSTER)
end
function c65050183.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050183.confil1,1,nil) and not eg:IsContains(e:GetHandler())
end
function c65050183.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65050183.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end


function c65050183.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x9da8) and not eg:IsContains(e:GetHandler())
end
function c65050183.stfil(c)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c65050183.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050183.stfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c65050183.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65050183.stfil,tp,LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end