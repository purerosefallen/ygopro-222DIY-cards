--意外对视·桃子
function c81040025.initial_effect(c)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81040025)
	e1:SetCost(c81040025.drcost)
	e1:SetTarget(c81040025.drtg)
	e1:SetOperation(c81040025.drop)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,81040925)
	e2:SetCondition(c81040025.con)
	e2:SetTarget(c81040025.thtg)
	e2:SetOperation(c81040025.thop)
	c:RegisterEffect(e2)
end
function c81040025.costfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x81c)
end
function c81040025.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040025.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c81040025.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c81040025.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81c) and c:IsType(TYPE_MONSTER)
end
function c81040025.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=1
	if Duel.IsExistingMatchingCard(c81040025.cfilter,tp,LOCATION_REMOVED,0,10,nil) then ct=2 end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c81040025.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c81040025.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81040025.filter(c)
	return c:IsSetCard(0x81c) and not c:IsCode(81040025) and c:IsAbleToHand()
end
function c81040025.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c81040025.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81040025.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81040025.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81040025.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
