--梦中的答案·最上静香
require("expansions/script/c81000000")
function c81018044.initial_effect(c)
	Tenka.Shizuka(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81018044)
	e1:SetCondition(c81018044.spcon)
	e1:SetTarget(c81018044.sptg)
	e1:SetOperation(c81018044.spop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81018944)
	e2:SetCondition(c81018044.atkcon)
	e2:SetOperation(c81018044.atkop)
	c:RegisterEffect(e2)
end
function c81018044.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local atk=g:GetSum(Card.GetAttack)
	return atk>=8000
end
function c81018044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81018044.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c81018044.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81b)
end
function c81018044.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	local gc=Duel.GetMatchingGroupCount(c81018044.atkfilter,tp,LOCATION_MZONE,0,nil)
	return a:IsControler(tp) and a:IsSetCard(0x81b) and d
		and d:IsFaceup() and not d:IsControler(tp) and gc>0
end
function c81018044.atkop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttacker():GetBattleTarget()
	local gc=Duel.GetMatchingGroupCount(c81018044.atkfilter,tp,LOCATION_MZONE,0,nil)
	if d:IsRelateToBattle() and d:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(gc*500)
		d:RegisterEffect(e1)
	end
end
