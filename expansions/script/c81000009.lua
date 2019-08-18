--甜美之花·桑山千雪
function c81000009.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c81000009.damval)
	c:RegisterEffect(e1)
	--battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81000009)
	e2:SetCondition(c81000009.damcon1)
	e2:SetCost(c81000009.cost)
	e2:SetTarget(c81000009.damtg1)
	e2:SetOperation(c81000009.damop1)
	c:RegisterEffect(e2)
end
function c81000009.damval(e,re,val,r,rp,rc)
	local atk=e:GetHandler():GetLinkedGroupCount()*1500
	if val<=atk and bit.band(r,REASON_EFFECT)~=0 then return 0 else return val end
end
function c81000009.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:IsControler(1-tp)
end
function c81000009.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c81000009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81000009.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c81000009.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c81000009.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLinkedGroupCount()>0 end
end
function c81000009.damop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c81000009.damcon3)
	e1:SetOperation(c81000009.damop3)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81000009.damcon3(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetLinkedGroupCount()*1500
	return Duel.GetBattleDamage(tp)<=ct
end
function c81000009.damop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
