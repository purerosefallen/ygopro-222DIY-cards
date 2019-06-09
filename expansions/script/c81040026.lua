--纯粹行者·周子
function c81040026.initial_effect(c)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81040026.atkval)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,81040926)
	e2:SetCondition(c81040026.con)
	e2:SetTarget(c81040026.target)
	e2:SetOperation(c81040026.operation)
	c:RegisterEffect(e2)
end
function c81040026.atkfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c81040026.atkval(e,c)
	return Duel.GetMatchingGroupCount(c81040026.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)*200
end
function c81040026.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81040026.filter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c81040026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040026.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c81040026.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81040026.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local b1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local b2=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local b3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,nil)
		if tc:IsRace(RACE_WARRIOR) and #b1>0 and Duel.SelectYesNo(tp,aux.Stringid(81040026,1)) then
			local t1=b1:GetFirst()
			while t1 do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(500)
				t1:RegisterEffect(e1)
				t1=b1:GetNext()
			end
		end
		if tc:IsAttribute(ATTRIBUTE_WATER) and #b2>0 and Duel.SelectYesNo(tp,aux.Stringid(81040026,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local t2=b2:Select(tp,1,1,nil)
			Duel.HintSelection(t2)
			Duel.Destroy(t2,REASON_EFFECT)
		end
		if tc:IsType(TYPE_RITUAL) and tc:IsType(TYPE_MONSTER)  and #b3>0  and Duel.SelectYesNo(tp,aux.Stringid(81040026,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local t3=b3:Select(tp,1,1,nil)
			Duel.HintSelection(t3)
			Duel.Remove(t3,POS_FACEUP,REASON_EFFECT)
		end
	end
end
