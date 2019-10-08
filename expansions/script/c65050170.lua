--蜜食彩虹糕点 果酱
function c65050170.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6da8),6,2)
	c:EnableReviveLimit()
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050170,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65050170)
	e1:SetCost(c65050170.atkcost)
	e1:SetCondition(c65050170.atkcon)
	e1:SetTarget(c65050170.atktg)
	e1:SetOperation(c65050170.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(65050170,1))
	e3:SetTarget(c65050170.atktg2)
	e3:SetOperation(c65050170.atkop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--tograve
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,65050171)
	e5:SetCondition(c65050170.con)
	e5:SetTarget(c65050170.tg)
	e5:SetOperation(c65050170.op)
	c:RegisterEffect(e5)
end
function c65050170.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c65050170.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsSetCard(0x6da8) 
end
function c65050170.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050170.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050170.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65050170.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c65050170.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function c65050170.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65050170.tgf1(c)
	return c:IsFaceup() and not c:IsAttack(0)
end
function c65050170.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c65050170.tgf1,1,nil)
	if chk==0 then return g:GetCount()>0 end
end
function c65050170.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65050170.tgf1,1,nil)
	local gc=g:GetFirst()
	while gc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		gc:RegisterEffect(e1)
		gc=g:GetNext()
	end
end
function c65050170.tgf2(c)
	return c:IsFaceup() and not c:IsAttack(2000)
end
function c65050170.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c65050170.tgf1,1,nil)
	if chk==0 then return g:GetCount()>0 end
end
function c65050170.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65050170.tgf1,1,nil)
	local gc=g:GetFirst()
	while gc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		gc:RegisterEffect(e1)
		gc=g:GetNext()
	end
end