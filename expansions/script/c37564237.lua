--さわわ-幻桜
local m=37564237
local cm=_G["c"..m]
Duel.LoadScript("c37564765.lua")
cm.Senya_name_with_sawawa=true
function cm.initial_effect(c)
	Senya.SawawaCommonEffect(c,2,true,false,false)
	Senya.NegateEffectModule(c,1,m,Senya.SawawaRemoveCost(2),Senya.CheckNoExtra)
end
