--沁恋甜心 优雅之牡丹
function c65050087.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65050087.ffilter,3,true)
	--chain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65050087.con)
	e1:SetTarget(c65050087.tg)
	e1:SetOperation(c65050087.op)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcda2))
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c65050087.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c65050087.ng1fil(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToGrave()
end
function c65050087.ng2fil(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave()
end
function c65050087.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65050087.ng1fil,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65050087.ng2fil,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=2
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(65050087,0),aux.Stringid(65050087,1))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	end
	if op==0 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	elseif op==1 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65050087,op))
	e:SetLabel(op)
end
function c65050087.op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g1=Duel.SelectMatchingCard(tp,c65050087.ng1fil,tp,LOCATION_EXTRA,0,1,1,nil)
		if g1:GetCount()>0 and Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
			if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end
		end
	elseif op==1 then
		local g2=Duel.SelectMatchingCard(tp,c65050087.ng2fil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g2:GetCount()>0 and Duel.SendtoGrave(g2,REASON_EFFECT)~=0 then
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.HintSelection(dg)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end

function c65050087.ffilter(c)
	return c:IsFusionSetCard(0xcda2) and c:IsLevelAbove(6)
end