--恶梦启示 衰弱
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330409
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e3=rsnm.SummonFun(c,m)   
	local e4=rsnm.FilpFun(c,m,"dis",nil,rsop.target(aux.disfilter1,"dis",LOCATION_ONFIELD,LOCATION_ONFIELD),cm.op)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	rsof.SelectHint(tp,"dis")
	local tc=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(rsgf.Mix2(tc))
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est)
end