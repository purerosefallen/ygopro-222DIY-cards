--御刀流 后之先
local m=20100236
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100000") end,function() require("script/c20100000") end)
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE+LOCATION_FZONE)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE+LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(cm.atkcon)
	e4:SetTarget(cm.atktg)
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)	
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0xc90) and d:IsAttackable()
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if Duel.NegateAttack() then
			Duel.BreakEffect()
			Duel.CalculateDamage(at,ac)
		end
	end
end

function cm.atkcon(e)
	local tp=e:GetHandler():GetControler()
	local ph=Duel.GetCurrentPhase()
	local pl=Duel.GetTurnPlayer()
	local ac=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	local fct=Duel.GetFlagEffect(1-tp,20100000)
	return ac and ac:IsSetCard(0xc90) and at and ph==PHASE_DAMAGE_CAL and pl==(1-tp) and fct>0
end

function cm.atktg(e,c)
	return c:IsSetCard(0xc90) and c:IsFaceup() and c:IsRelateToBattle()
end

function cm.atkval(e,c)
	local ac=Duel.GetAttacker()
	local at=ac:GetBattleTarget()
	return at:GetAttack()
end
