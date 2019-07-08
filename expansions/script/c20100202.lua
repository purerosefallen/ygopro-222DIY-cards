--御刀使-六角清香
local m=20100202
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100000") end,function() require("script/c20100000") end)
function cm.initial_effect(c)
	C9.TojiMonster(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetCountLimit(1,m)
	c:RegisterEffect(e1)	
end

function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc90) and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
end