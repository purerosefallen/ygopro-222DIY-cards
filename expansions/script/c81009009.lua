--华美之宴·高垣枫
function c81009009.initial_effect(c)
	c:SetSPSummonOnce(81009009)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c81009009.ovfilter,aux.Stringid(81009009,0))
	c:EnableReviveLimit()
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81009909)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81009009.mattg)
	e2:SetOperation(c81009009.matop)
	c:RegisterEffect(e2)
	--disable special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81009009,1))
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,81009009)
	e5:SetCondition(c81009009.discon)
	e5:SetCost(c81009009.discost)
	e5:SetTarget(c81009009.distg)
	e5:SetOperation(c81009009.disop)
	c:RegisterEffect(e5)
end
function c81009009.ovfilter(c)
	return c:IsFaceup() and c:IsCode(81009011)
end
function c81009009.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c81009009.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c81009009.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c81009009.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c81009009.xyzfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_XYZ)
end
function c81009009.matfilter(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER)
end
function c81009009.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c81009009.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81009009.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c81009009.matfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81009009.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81009009.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c81009009.matfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
