--醒觉-忆景
function c65050064.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2,c65050064.ovfilter,aux.Stringid(65050064,0))
	c:EnableReviveLimit()
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetLabel(1)
	e1:SetCondition(c65050064.effcon)
	e1:SetTarget(c65050064.tg1)
	e1:SetOperation(c65050064.op1)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050064,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(2)
	e2:SetCondition(c65050064.effcon2)
	e2:SetCost(c65050064.cost)
	e2:SetTarget(c65050064.tdtg)
	e2:SetOperation(c65050064.tdop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65050064,3))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(3)
	e3:SetCondition(c65050064.effcon2)
	e3:SetCost(c65050064.cost)
	e3:SetTarget(c65050064.negtg)
	e3:SetOperation(c65050064.negop)
	c:RegisterEffect(e3)
end
function c65050064.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xada2) and c:IsType(TYPE_XYZ)
end
function c65050064.effcon(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	local ng=og:Filter(Card.IsType,nil,TYPE_XYZ)
	return ng:GetCount()>=e:GetLabel()
end
function c65050064.effcon2(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetHandler():GetOverlayGroup()
	local ng=og:Filter(Card.IsType,nil,TYPE_XYZ)
	return ng:GetCount()>=e:GetLabel() and rp~=tp
end
function c65050064.tg1f(c)
	return c:IsSetCard(0xada2) and c:IsType(TYPE_MONSTER) 
end
function c65050064.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050064.tg1f,tp,LOCATION_GRAVE,0,1,nil) end
end
function c65050064.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c65050064.tg1f,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Overlay(e:GetHandler(),g)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(65050064,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(e:GetHandler(),nseq)
		end
	end
end

function c65050064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65050064.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65050064.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c65050064.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65050064.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev) 
end