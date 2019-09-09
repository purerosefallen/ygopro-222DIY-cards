--猛毒性 虚络
function c24562477.initial_effect(c)
	aux.AddXyzProcedure(c,c24562477.mfilter,3,2,c24562477.ovfilter,aux.Stringid(24562477,0),2,c24562477.xyzop)
	c:EnableReviveLimit()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(c24562477.valcon)
	c:RegisterEffect(e4)
--ATKCHANGE
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(24562477,1))
	e1:SetRange(LOCATION_MZONE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,24562477)
	e1:SetCost(c24562477.cost)
	e1:SetTarget(c24562477.seqtg)
	e1:SetOperation(c24562477.seqop)
	c:RegisterEffect(e1)
--DESTROY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24562477,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,24562477)
	e2:SetCost(c24562477.cost)
	e2:SetTarget(c24562477.destg)
	e2:SetOperation(c24562477.desop)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24562477,4))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1,24562443)
	e3:SetCondition(c24562477.damcon)
	e3:SetTarget(c24562477.e3tg)
	e3:SetOperation(c24562477.damop)
	c:RegisterEffect(e3)
end
function c24562477.g2fil(c,tp)
	return c:GetAttack()>0 and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c24562477.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c24562477.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsFaceup() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	if Duel.MoveSequence(c,nseq)~=0 then
		Duel.BreakEffect()
		local g=c:GetColumnGroup():Filter(c24562477.g2fil,nil,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24562477,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			ga=g:Select(tp,0,1,nil)
			tc=ga:GetFirst()
			local atk=tc:GetBaseAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				e2:SetValue(atk)
				c:RegisterEffect(e2)
			end
		end
	end
end
--damage
function c24562477.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local btk=c:GetBaseAttack()
	local atk=c:GetAttack()
	local ct=atk-btk
	if chk==0 then return ct>0 
		and Duel.GetFlagEffect(tp,24562477)==0 end
	Duel.RegisterFlagEffect(tp,24562477,RESET_CHAIN,0,1)
end
function c24562477.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local btk=c:GetBaseAttack()
	local atk=c:GetAttack()
	local ct=atk-btk
	if ct>0 then
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct)
	end
end
function c24562477.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local btk=c:GetBaseAttack()
	local atk=c:GetAttack()
	if c:GetOverlayGroup():Filter(Card.IsSetCard,nil,0x9390):GetCount()>0 
	and btk<atk
	then return true end
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x9390) and rp==tp
end
--
function c24562477.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c24562477.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dam=c:GetAttack()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 and tc then
		local def=tc:GetBaseDefense()
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and dam>def and Duel.SelectYesNo(tp,aux.Stringid(24562477,3)) then
			Duel.Damage(1-tp,dam-def,REASON_EFFECT)
		end
	end
end
--
function c24562477.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c24562477.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c24562477.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9390) and c:IsAttackAbove(2000)
end
function c24562477.xyzopfil(c)
	return c:IsSetCard(0x9390) and c:IsAbleToGraveAsCost()
end
function c24562477.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562477.xyzopfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c24562477.xyzopfil,1,1,REASON_COST,nil)
end
function c24562477.mfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsAttribute(ATTRIBUTE_WATER)
end