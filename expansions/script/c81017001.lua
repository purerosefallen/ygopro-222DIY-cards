--偶像·高山纱代子
function c81017001.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c81017001.spcon)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,81017001)
	e1:SetCondition(c81017001.condition)
	e1:SetCost(c81017001.cost)
	e1:SetTarget(c81017001.target)
	e1:SetOperation(c81017001.operation)
	c:RegisterEffect(e1)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c81017001.atkcon)
	e5:SetValue(2000)
	c:RegisterEffect(e5)
end
function c81017001.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x819)
end
function c81017001.spfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c81017001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsExistingMatchingCard(c81017001.spfilter1,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.IsExistingMatchingCard(c81017001.spfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c81017001.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsRace(RACE_FAIRY) and c:IsReason(REASON_BATTLE) 
end
function c81017001.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81017001.cfilter,1,nil)
end
function c81017001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c81017001.filter(c,e,tp)
	return c:IsSetCard(0x819) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81017001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81017001.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c81017001.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81017001.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c81017001.atkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c81017001.spfilter2,tp,0,LOCATION_MZONE,1,nil)
end
