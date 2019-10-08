--奇妙仙灵 白翼
function c65050199.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.ritlimit)
	c:RegisterEffect(e4)
	--swap
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SWAP_BASE_AD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65050199.con)
	c:RegisterEffect(e1)
	--cannot trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c65050199.actop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c65050199.con1)
	e3:SetTarget(c65050199.tg)
	e3:SetOperation(c65050199.op)
	c:RegisterEffect(e3)
	local e0=e3:Clone()
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCondition(c65050199.con2)
	c:RegisterEffect(e0)
end
function c65050199.mat_filter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(6)
end
function c65050199.con(e)
	return e:GetHandler():IsAttackPos()
end
function c65050199.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x9da8) and rc:IsLevelAbove(6) and ep==tp then
		Duel.SetChainLimit(c65050199.chainlm)
	end
end
function c65050199.chainlm(e,rp,tp)
	return tp==rp
end

function c65050199.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050199.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050199.tgfil(c)
	return c:IsFaceup() and (c:IsLevelAbove(6) or c:GetLevel()<=0) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c65050199.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050199.tgfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c65050199.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c65050199.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c65050199.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end