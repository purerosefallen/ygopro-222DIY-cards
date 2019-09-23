--沁恋甜心 樱粉之春
function c65050071.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65050071)
	e1:SetCondition(c65050071.spcon)
	e1:SetTarget(c65050071.sptg)
	e1:SetOperation(c65050071.spop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65050072)
	e2:SetCondition(c65050071.con)
	e2:SetTarget(c65050071.tg)
	e2:SetOperation(c65050071.op)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c65050071.tnval)
	c:RegisterEffect(e3)
end
function c65050071.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end

function c65050071.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c65050071.tgfil(c)
	return c:IsSetCard(0xcda2) and c:IsLevelAbove(6) and Duel.IsExistingMatchingCard(c65050071.thfil,tp,LOCATION_DECK,0,1,nil,c:GetLevel()) and c:IsFaceup()
end
function c65050071.thfil(c,lv)
	return c:IsSetCard(0xcda2) and c:IsType(TYPE_MONSTER) and c:GetLevel()<lv and c:IsAbleToHand()
end
function c65050071.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65050071.tgfil(c) end
	if chk==0 then return Duel.IsExistingTarget(c65050071.tgfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c65050071.tgfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050071.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,c65050071.thfil,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
	if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if tc:IsRelateToEffect(e) then
			local lv=g:GetFirst():GetLevel()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end


function c65050071.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcda2) 
end
function c65050071.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65050071.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c65050071.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65050071.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end