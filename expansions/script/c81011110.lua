--宫水静香
function c81011110.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e3=aux.AddRitualProcGreater2(c,c81011110.filter,nil,nil,c81011110.mfilter)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetCountLimit(1,81011110)
	e3:SetRange(LOCATION_MZONE)
end
function c81011110.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81011110.mfilter(c,e,tp)
	return c:IsAttack(1550)
end
