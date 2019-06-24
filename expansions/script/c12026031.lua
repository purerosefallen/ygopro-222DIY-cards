--三位一体的女神 拉结尔
function c12026031.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1fbd),3,2)
	c:EnableReviveLimit()
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12026031,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c12026031.xyztg)
	e3:SetOperation(c12026031.xyzop)
	c:RegisterEffect(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12026031,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,12026031+100)
	e2:SetCondition(c12026031.spcon)
	e2:SetTarget(c12026031.sptg)
	e2:SetOperation(c12026031.spop)
	c:RegisterEffect(e2)
end
function c12026031.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c12026031.xyzfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c12026031.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12026031.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12026031.xyzfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12026031,2))
	local g=Duel.SelectTarget(tp,c12026031.xyzfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c12026031.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c12026031.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(c:GetOverlayCount())
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function c12026031.tfilter(c,code)
	return  c:IsCode(code) and c:IsAbleToHand()
end
function c12026031.cfilter(c,e,tp)
	local cs=e:GetLabel()
	return c:IsSetCard(0x1fbd) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c12026031.tfilter,tp,LOCATION_DECK,0,cs-1,nil,c:GetCode())
end

function c12026031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cs=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(c12026031.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,cs,tp,LOCATION_DECK)
end
function c12026031.spop(e,tp,eg,ep,ev,re,r,rp)
	local cs=e:GetLabel()
	if not Duel.IsExistingMatchingCard(c12026031.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	local g=Duel.SelectMatchingCard(tp,c12026031.cfilter,tp,LOCATION_DECK,0,0,1,nil,e,tp)
	local tg=Duel.SelectMatchingCard(tp,c12026031.tfilter,tp,LOCATION_DECK,0,cs-1,cs-1,g:GetFirst(),g:GetFirst():GetCode())
	g:Merge(tg)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
