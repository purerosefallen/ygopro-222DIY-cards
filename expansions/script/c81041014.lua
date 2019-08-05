--烦恼相谈·四条凛香
function c81041014.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--atk
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetCondition(c81041014.atkcon)
	e0:SetValue(c81041014.atkval)
	c:RegisterEffect(e0)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81041014)
	e1:SetTarget(c81041014.target)
	e1:SetOperation(c81041014.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c81041014.drcon)
	e2:SetOperation(c81041014.drop)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,81041914)
	e4:SetTarget(c81041014.damtg)
	e4:SetOperation(c81041014.damop)
	c:RegisterEffect(e4)
end
function c81041014.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c81041014.atkval(e,c)
	return c:GetLevel()*300
end
function c81041014.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsCanBeEffectTarget(e)
end
function c81041014.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c81041014.cfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c81041014.cfilter,1,nil,e,1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c81041014.cfilter,1,1,nil,e,1-tp)
	Duel.SetTargetCard(g)
end
function c81041014.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c81041014.cfilter(c,tp)
	return c:IsReason(REASON_RELEASE) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function c81041014.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81041014.cfilter,1,nil,tp)
end
function c81041014.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c81041014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and e:GetHandler():IsLevelAbove(4) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c81041014.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsLevelBelow(3) then return end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_LEVEL)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e0:SetValue(-3)
	c:RegisterEffect(e0)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
