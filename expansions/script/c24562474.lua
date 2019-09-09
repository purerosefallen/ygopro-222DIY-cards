--猛毒性 厉蝎
function c24562474.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,24562459,c24562474.f2fil,c24562474.f3fil)
	--battle indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetOperation(c24562474.dmgop)
	e1:SetCondition(c24562474.e1con)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCondition(c24562474.e1con2)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(24562474,2))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DAMAGE_STEP_END)
	e7:SetCondition(c24562474.rmcon)
	e7:SetTarget(c24562474.rmtg)
	e7:SetOperation(c24562474.rmop)
	c:RegisterEffect(e7)
end
function c24562474.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return c==Duel.GetAttacker() and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function c24562474.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c24562474.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsChainAttackable() then
			Duel.ChainAttack()
		end
end
---
function c24562474.f2fil(c)
	return c:IsSetCard(0x9390)
end
function c24562474.f3fil(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH)
end
function c24562474.e1con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker():GetControler()==tp then
		if Duel.GetAttackTarget()==nil then return false end
	end
	return true
end
function c24562474.e1con2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker():GetControler()==1-tp then
		if Duel.GetAttackTarget()~=e:GetHandler() then return false end
	end
	return true
end
function c24562474.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if Duel.GetAttackTarget()==nil then return false end
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(24562474,3))
		e5:SetCategory(CATEGORY_DAMAGE)
		e5:SetType(EFFECT_TYPE_QUICK_F)
		e5:SetCode(EVENT_CHAINING)
		e5:SetRange(LOCATION_MZONE)
		e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e5:SetCost(c24562474.e5cost)
		e5:SetTarget(c24562474.e5tg)
		e5:SetOperation(c24562474.e5op)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5)
		tc:RegisterFlagEffect(24562474,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(24562474,1))
end
function c24562474.e5op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c24562474.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,500)
end
function c24562474.e5cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c24562474.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end