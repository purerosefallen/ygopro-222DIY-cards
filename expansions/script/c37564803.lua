--3L·Sweets Magic
local m=37564803
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
cm.fusion_att_3L=ATTRIBUTE_FIRE
function cm.initial_effect(c)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_FUSION)
	Senya.Fusion_3L_Attribute(c,cm)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1000)
	c:RegisterEffect(e2)	
end
