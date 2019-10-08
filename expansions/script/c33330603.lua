--相对性非规则碎片
function c33330603.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c33330603.cost)
	e1:SetTarget(c33330603.tg)
	e1:SetOperation(c33330603.op)
	c:RegisterEffect(e1)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c33330603.costfil(c,tp)
	local atk=c:GetTextAttack()
	local def=c:GetTextDefense()
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c33330603.thfil,tp,LOCATION_DECK,0,1,nil,atk,def) and not c:IsType(TYPE_LINK)
end
function c33330603.thfil(c,atk,def)
	return c:IsAttack(atk) and c:IsDefense(def) and c:IsAbleToHand()
end
function c33330603.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return g:IsExists(c33330603.costfil,1,nil,tp) end
	local rg=g:Filter(c33330603.costfil,nil,tp):FilterSelect(tp,aux.TRUE,1,1,nil)
	Duel.SendtoGrave(rg,REASON_COST)
	e:SetLabelObject(rg:GetFirst())
end
function c33330603.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33330603.op(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,c33330603.thfil,tp,LOCATION_DECK,0,1,1,nil,rc:GetTextAttack(),rc:GetTextDefense())
	if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c33330603.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c33330603.discon)
		e2:SetOperation(c33330603.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c33330603.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33330603.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c33330603.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end