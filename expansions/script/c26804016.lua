--德川茉莉战备中
function c26804016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c26804016.condition)
	e1:SetTarget(c26804016.target)
	e1:SetOperation(c26804016.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c26804016.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c26804016.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x600)
end
function c26804016.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26804016.dfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetCurrentChain()==0 and eg:IsExists(c26804016.filter,1,nil)
end
function c26804016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c26804016.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c26804016.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c26804016.filter,nil)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
