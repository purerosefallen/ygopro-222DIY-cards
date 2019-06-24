--熊猫爱好者·最上静香
require("expansions/script/c81000000")
function c81018038.initial_effect(c)
	Tenka.Shizuka(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()
	--atkup
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c81018038.atkval)
	c:RegisterEffect(e0)
	--redirect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81018038)
	e1:SetCost(c81018038.dacost)
	e1:SetTarget(c81018038.datg)
	e1:SetOperation(c81018038.daop)
	c:RegisterEffect(e1)
end
function c81018038.atkval(e,c)
	return Duel.GetCounter(c:GetControler(),1,1,0x1810)*-200
end
function c81018038.sfilter(c)
	return c:IsFaceup() and c:IsPosition(POS_FACEUP_ATTACK)
end
function c81018038.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81018038.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81018038.sfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c81018038.daop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81018038.sfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1810,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c81018038.condition)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_MUST_ATTACK)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(81018038,RESET_EVENT+RESETS_STANDARD,0,0)
		tc=g:GetNext()
	end
end
function c81018038.condition(e)
	return e:GetHandler():GetCounter(0x1810)>0 and e:GetHandler():GetFlagEffect(81018038)~=0
end
