--清晨阳光·岛村卯月
function c81007035.initial_effect(c)
	aux.EnableDualAttribute(c)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c81007035.aclimit)
	e1:SetCondition(c81007035.actcon)
	c:RegisterEffect(e1)
end
function c81007035.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c81007035.actcon(e)
	return aux.IsDualState(e) and Duel.GetAttacker()==e:GetHandler()
end
