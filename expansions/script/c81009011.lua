--恋风·高垣枫
function c81009011.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_XYZ),1,1)
	c:EnableReviveLimit()
	--effect gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetCondition(c81009011.efcon)
	e0:SetOperation(c81009011.efop)
	c:RegisterEffect(e0)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81009011,0))
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c81009011.xyzcon)
	e4:SetOperation(c81009011.xyzop)
	c:RegisterEffect(e4)
end
function c81009011.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabelObject(tc)
	return tc and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE) and not tc:IsType(TYPE_TOKEN)
end
function c81009011.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsFaceup() and c:IsType(TYPE_XYZ) then
		Duel.Overlay(c,tc)
	end
end
function c81009011.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c81009011.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c81009011.sumcon)
	e1:SetOperation(c81009011.sumsuc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function c81009011.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c81009011.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(81009011,1))
end
