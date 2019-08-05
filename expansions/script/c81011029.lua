--玫瑰天堂·砂冢明音
function c81011029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81011029,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81011029)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c81011029.negcon)
	e2:SetCost(c81011029.negcost)
	e2:SetTarget(c81011029.negtg)
	e2:SetOperation(c81011029.negop)
	c:RegisterEffect(e2)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81011929)
	e4:SetTarget(c81011029.mttg)
	e4:SetOperation(c81011029.mtop)
	c:RegisterEffect(e4)
end
function c81011029.mtfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsControler(tp) or c:IsAbleToChangeControler()) and not c:IsImmuneToEffect(e)
end
function c81011029.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c81011029.mtfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) end
end
function c81011029.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c81011029.mtfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c81011029.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
end
function c81011029.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c81011029.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and e:GetLabelObject():IsType(TYPE_CONTINUOUS) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
	end
end
function c81011029.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and e:GetLabelObject():IsType(TYPE_CONTINUOUS) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
