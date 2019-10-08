--奇妙仙灵 彩片翼
function c65050202.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x9da8),1)
	c:EnableReviveLimit()
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050202,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65050202)
	e1:SetCondition(c65050202.con1)
	e1:SetTarget(c65050202.tg)
	e1:SetOperation(c65050202.op)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCondition(c65050202.con2)
	c:RegisterEffect(e0)
	 --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050202,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65050203)
	e2:SetCondition(c65050202.condition1)
	e2:SetTarget(c65050202.target)
	e2:SetOperation(c65050202.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCondition(c65050202.condition2)
	c:RegisterEffect(e3)
end
function c65050202.condfil(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c65050202.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211) and Duel.IsExistingMatchingCard(c65050202.condfil,tp,LOCATION_MZONE,0,1,nil)
end
function c65050202.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211) and Duel.IsExistingMatchingCard(c65050202.condfil,tp,LOCATION_MZONE,0,1,nil)
end
function c65050202.filter(c,e,tp)
	return c:IsSetCard(0x9da8) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsLevel(3)
end
function c65050202.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c65050202.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050202.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c65050202.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65050202.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65050202.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050202.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050202.tgfil(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(6) and c:IsType(TYPE_TUNER)
end
function c65050202.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050202.tgfil(chkc,tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050202.tgfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c65050202.tgfil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c65050202.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--nontuner
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c65050202.tnval)
	tc:RegisterEffect(e1)
	end
end
function c65050202.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
