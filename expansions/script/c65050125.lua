--闪耀侍者 天然之黄蜡
function c65050125.initial_effect(c)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050125,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65050125)
	e1:SetCost(c65050125.cost)
	e1:SetTarget(c65050125.tg)
	e1:SetOperation(c65050125.op)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050125,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,65050126)
	e2:SetCondition(c65050125.thcon)
	e2:SetTarget(c65050125.thtg)
	e2:SetOperation(c65050125.thop)
	c:RegisterEffect(e2)
end
function c65050125.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65050125.thfilter2(c)
	return c:IsSetCard(0x5da8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsType(TYPE_RITUAL)
end
function c65050125.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,2)
end
function c65050125.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsAbleToGrave,1,1,REASON_EFFECT,nil)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end

function c65050125.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT)
end
function c65050125.thfilter(c)
	return c:IsSetCard(0x5da8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function c65050125.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050125.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65050125.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65050125.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
