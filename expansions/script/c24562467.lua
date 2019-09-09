--+++++猛毒性 刺针
function c24562467.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,24562466,c24562467.f2fil,c24562467.f3fil)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c24562467.counter)
	c:RegisterEffect(e1)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24562466,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,24562466)
	e4:SetCondition(c24562467.e4con)
	e4:SetCost(c24562467.e4cost)
	e4:SetTarget(c24562467.e4tg)
	e4:SetOperation(c24562467.e4op)
	c:RegisterEffect(e4)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562466,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c24562467.tdcon)
	e2:SetCost(c24562467.e2cost)
	e2:SetTarget(c24562467.tdtg)
	e2:SetOperation(c24562467.tdop)
	c:RegisterEffect(e2)
end
function c24562467.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
end
function c24562467.e2costfil(c)
	return c:IsSetCard(0x9390) and c:IsAbleToRemoveAsCost()
end
function c24562467.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c24562467.e2costfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562467.e2costfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24562467.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c24562467.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
--
function c24562467.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c24562467.e4op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,e:GetHandler():GetAttack(),REASON_EFFECT)
end
function c24562467.e4cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c24562467.e4con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x9390)>=3
end
--
function c24562467.e2cfil(c)
	return c:IsSetCard(0x9390) and c:IsFaceup()
end
function c24562467.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c24562467.e2cfil,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x9390,ct)
	end
end
function c24562467.f2fil(c)
	return c:IsSetCard(0x9390)
end
function c24562467.f3fil(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK)
end