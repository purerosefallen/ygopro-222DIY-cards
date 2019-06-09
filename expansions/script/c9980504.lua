--柱男·卡兹/解放形态
function c9980504.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,9980504)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c9980504.spcon)
	e1:SetOperation(c9980504.spop)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980504,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9980504)
	e1:SetCost(c9980504.thcost)
	e1:SetTarget(c9980504.thtg)
	e1:SetOperation(c9980504.thop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c9980504.aclimit)
	e2:SetCondition(c9980504.actcon)
	c:RegisterEffect(e2)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c9980504.antarget)
	c:RegisterEffect(e8)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetOperation(c9980504.sumsuc)
	c:RegisterEffect(e8)
	local e4=e8:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c9980504.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980504,1))
end
function c9980504.gfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ROCK) and c:IsAbleToRemoveAsCost()
end
function c9980504.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9980504.gfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c9980504.gfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler())
end
function c9980504.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c9980504.gfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	local g3=Duel.SelectMatchingCard(tp,c9980504.gfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c9980504.antarget(e,c)
	return c~=e:GetHandler()
end
function c9980504.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9980504.thfilter(c)
	return c:IsSetCard(0x6bcc,0x5bcc) and c:IsAbleToHand()
end
function c9980504.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980504.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9980504.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980504.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980504.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9980504.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end