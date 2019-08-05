--The SkyScrapers
function c26807057.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,nil,nil,nil,c26807057.mfilter)
	e1:SetCountLimit(1,26807057+EFFECT_COUNT_CODE_OATH)
end
function c26807057.mfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSummonableCard()
end