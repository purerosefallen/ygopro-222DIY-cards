--圣诞之约·北上丽花
require("expansions/script/c81000000")
function c81015040.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x81a),3)
	c:EnableReviveLimit()
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetCondition(c81015040.indcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81015040,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81015040)
	e2:SetCondition(c81015040.condition)
	e2:SetTarget(c81015040.target)
	e2:SetOperation(c81015040.operation)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1,81015940)
	e3:SetCondition(c81015040.rmcon)
	e3:SetTarget(c81015040.rmtg)
	e3:SetOperation(c81015040.rmop)
	c:RegisterEffect(e3)
end
function c81015040.indcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c81015040.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x81a)
end
function c81015040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81015040.cfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c81015040.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81015040.tdfilter(c)
	return c:IsSetCard(0x81a) and c:IsAbleToDeck()
end
function c81015040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c81015040.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(c81015040.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local lg=Duel.SelectTarget(tp,c81015040.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81015040.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,lg,1,tp,LOCATION_GRAVE)
end
function c81015040.operation(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=g:GetFirst()
	if lc==sc then lc=g:GetNext() end
	if lc and lc:IsRelateToEffect(e) and Duel.SendtoDeck(lc,nil,2,REASON_EFFECT)>0 and lc:IsLocation(LOCATION_DECK) and sc and sc:IsRelateToEffect(e) then
		Duel.Destroy(sc,REASON_EFFECT)
	end
end
function c81015040.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Tenka.ReikaCon(e)
end
function c81015040.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsAbleToRemove() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function c81015040.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*400)
		c:RegisterEffect(e1)
	end
end
