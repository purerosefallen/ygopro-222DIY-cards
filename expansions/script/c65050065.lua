--流忆碎景
function c65050065.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,65050065)
	e1:SetCondition(c65050065.con)
	e1:SetTarget(c65050065.tg)  
	e1:SetOperation(c65050065.op)
	c:RegisterEffect(e1)
	--tog
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,65050066)
	e2:SetCondition(c65050065.tgcon)
	e2:SetTarget(c65050065.tgtg)
	e2:SetOperation(c65050065.tgop)
	c:RegisterEffect(e2)
end
function c65050065.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 
end
function c65050065.filter(c,e)
   return c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsCanBeEffectTarget(e) and c:IsSetCard(0xada2)
end
function c65050065.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c65050065.filter(chkc,e) end
	if chk==0 then return eg:IsExists(c65050065.filter,1,nil,e) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_XYZ) end
	Duel.SetTargetCard(eg)
end
function c65050065.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_XYZ)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end

function c65050065.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_XYZ)
end
function c65050065.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c65050065.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,1,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
			local gc=g1:GetFirst()
			while gc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				gc:RegisterEffect(e1)
				gc=g1:GetNext()
			end
		end
	end
end