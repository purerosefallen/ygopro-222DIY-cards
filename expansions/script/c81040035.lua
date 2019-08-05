--废墟之下的俯瞰
function c81040035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81040035.acttg)
	e1:SetOperation(c81040035.actop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EFFECT))
	e2:SetValue(-1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--cannot disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(c81040035.limcon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	c:RegisterEffect(e4)
	--cannot disable summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCondition(c81040035.limcon)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	c:RegisterEffect(e5)
	--cannot be target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCondition(c81040035.limcon)
	e6:SetTarget(c81040035.target)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e7)
end
function c81040035.desfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER)
end
function c81040035.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c81040035.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c81040035.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c81040035.desfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c81040035.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c81040035.limcon(e)
	return Duel.GetMatchingGroupCount(c81040035.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)>2
end
function c81040035.target(e,c)
	return c:IsType(TYPE_NORMAL)
end
