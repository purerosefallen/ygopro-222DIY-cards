--驱散之太阳雨
function c13255405.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c13255405.condition)
	e1:SetTarget(c13255405.target)
	e1:SetOperation(c13255405.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c13255405.cost1)
	e2:SetTarget(c13255405.target1)
	e2:SetOperation(c13255405.activate1)
	c:RegisterEffect(e2)
	
end
function c13255405.condition(e,tp,eg,ep,ev,re,r,rp)
	return ph<PHASE_BATTLE_START or ph>PHASE_BATTLE 
end
function c13255405.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(c13255405.chainlimit)
end
function c13255405.chainlimit(e,rp,tp)
	return tp==rp or not e:GetHandler():IsType(TYPE_EFFECT)
end
function c13255405.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	tg=tg:Filter(Card.IsRelateToEffect,nil)
	if tg:GetCount()>0 and Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)>0 then
		Duel.BreakEffect()
		local tg1=tg:Filter(IsControler,nil,tp)--tp
		tg:Sub(tg1)--1-tp
		if tg1:GetCount()>0 then
			local tc=tg1:Select(tp,1,1,nil):GetFirst()
			while tc do
				Duel.ReturnToField(tc)
				tg1:RemoveCard(tc)
				tc=tg1:Select(tp,1,1,nil):GetFirst()
			end
		end
		if tg:GetCount()>0 then
			tc=tg:Select(1-tp,1,1,nil):GetFirst()
			while tc do
				Duel.ReturnToField(tc)
				tg:RemoveCard(tc)
				tc=tg:Select(1-tp,1,1,nil):GetFirst()
			end
		end
	end
end
function c13255405.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13255405.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c13255405.activate1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)>0 then
		Duel.BreakEffect()
		Duel.ReturnToField(tc)
	end
end
