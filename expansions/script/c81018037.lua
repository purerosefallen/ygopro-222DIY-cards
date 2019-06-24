--粉红之声·最上静香
require("expansions/script/c81000000")
function c81018037.initial_effect(c)
	Tenka.Shizuka(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x81b),2,true)
	--cannot select battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(c81018037.atlimit)
	c:RegisterEffect(e1)
	--atk to 0
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81018037)
	e2:SetHintTiming(TIMING_BATTLE_START+TIMING_DAMAGE_STEP)
	e2:SetCondition(c81018037.atkcon)
	e2:SetTarget(c81018037.atktg)
	e2:SetOperation(c81018037.atkop)
	c:RegisterEffect(e2)
end
function c81018037.atlimit(e,c)
	return not (c:IsSetCard(0x81b) and c:IsFaceup())
end
function c81018037.ffilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(5)
end
function c81018037.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
		and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c81018037.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c81018037.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81018037.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c81018037.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local cn=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(cn)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
