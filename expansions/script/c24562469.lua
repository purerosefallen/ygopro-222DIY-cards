--猛毒性 害星
function c24562469.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,24562468,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9390),1,false,false)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24562469,0))
	e4:SetCountLimit(1)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c24562469.e4con)
	e4:SetTarget(c24562469.e4tg)
	e4:SetOperation(c24562469.e4op)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c24562469.e4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if tc and not tc:IsRelateToBattle() then return end
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then Duel.SendtoGrave(tc,REASON_EFFECT) return end
	Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e7=Effect.CreateEffect(c)
		e7:SetDescription(aux.Stringid(24562469,0))
		e7:SetCode(EFFECT_CHANGE_TYPE)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e7:SetReset(RESET_EVENT+0x1fc0000)
		e7:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e7)
		Duel.RaiseEvent(tc,EVENT_CUSTOM+47408488,e,0,tp,0,0)
		local e9=Effect.CreateEffect(c)
		e9:SetDescription(aux.Stringid(24562469,1))
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_ADD_CODE)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e9:SetValue(24562464)
		e9:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e9)
		local e8=Effect.CreateEffect(c)
		e8:SetDescription(aux.Stringid(24562469,2))
		e8:SetCategory(CATEGORY_DAMAGE)
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e8:SetRange(LOCATION_ONFIELD)
		e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e8:SetCountLimit(1)
		e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e8:SetReset(RESET_EVENT+0x1fe0000)
		e8:SetCondition(c24562469.damcon)
		e8:SetTarget(c24562469.damtg)
		e8:SetOperation(c24562469.damop)
		tc:RegisterEffect(e8)
end
function c24562469.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c24562469.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c24562469.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local dam=c:GetFlagEffectLabel(24762448)
	if dam==nil then
		c:RegisterFlagEffect(24762448,RESET_EVENT+0x1fe0000,0,0,200)
		dam=200
	else
		dam=dam*2
		c:SetFlagEffectLabel(24762448,dam)
	end
	Duel.Damage(tp,dam,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c24562469.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
end
function c24562469.e4con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc
end