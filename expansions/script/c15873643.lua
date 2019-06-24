--人格面具-死神爱丽丝
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873643
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	local e1=rsef.SV_INDESTRUCTABLE(c,"battle")
	local e2=rsef.I(c,{m,0},{1,m},"des",nil,LOCATION_MZONE,nil,nil,rstg.target2(cm.fun,rsop.list(aux.TRUE,nil,0,LOCATION_MZONE)),cm.desop)
	local e3=rsphh.ImmueFun(c,ATTRIBUTE_DARK)
	local e4=rsphh.EndPhaseFun(c,15873611)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,2)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local c1,c2=Duel.TossCoin(tp,2)
	if c1+c2<1 then return end
	Duel.Destroy(g,REASON_EFFECT)
end