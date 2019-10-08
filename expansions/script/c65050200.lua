--奇妙仙灵 柔片翼
function c65050200.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x9da8),1)
	c:EnableReviveLimit()
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050200,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050200)
	e1:SetCondition(c65050200.con1)
	e1:SetTarget(c65050200.tg)
	e1:SetOperation(c65050200.op)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCondition(c65050200.con2)
	c:RegisterEffect(e0)
	 --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050200,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65050201)
	e2:SetCondition(c65050200.condition1)
	e2:SetTarget(c65050200.target)
	e2:SetOperation(c65050200.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCondition(c65050200.condition2)
	c:RegisterEffect(e3)
end
function c65050200.condfil(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c65050200.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211) and Duel.IsExistingMatchingCard(c65050200.condfil,tp,LOCATION_MZONE,0,1,nil)
end
function c65050200.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211) and Duel.IsExistingMatchingCard(c65050200.condfil,tp,LOCATION_MZONE,0,1,nil)
end
function c65050200.filter(c)
	return c:IsSetCard(0x9da8) and c:IsAbleToHand()
end
function c65050200.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c65050200.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050200.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c65050200.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65050200.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c65050200.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050200.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050200.tgfil(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(6) and not c:IsType(TYPE_TUNER)
end
function c65050200.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050200.tgfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c65050200.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c65050200.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c65050200.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end