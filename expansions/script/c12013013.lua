--火枪手
function c12013013.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfb6),2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12013013,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12013013)
	e1:SetCost(c12013013.cost)
	e1:SetCondition(c12013013.condition)
	e1:SetTarget(c12013013.sptg)
	e1:SetOperation(c12013013.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12013013,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12013013+100)
	e2:SetCost(c12013013.thcost)
	e2:SetTarget(c12013013.thtg)
	e2:SetOperation(c12013013.thop)
	c:RegisterEffect(e2)
end
function c12013013.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12013013.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xfb6)
end
function c12013013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
end
function c12013013.spfilter(c)
	return c:IsAbleToHand() and c:IsRace(RACE_PLANT)
end
function c12013013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12013013.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12013013.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12013013.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function c12013013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c12013013.thfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end
function c12013013.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c12013013.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e) end
	Duel.SelectTarget(tp,c12013013.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,0,0,tp,0)
end
function c12013013.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
