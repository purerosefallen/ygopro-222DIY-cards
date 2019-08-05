--谐律 柔情弦乐
if not pcall(function() require("expansions/script/c18010001") end) then require("script/c18010001") end
local m=18010003
local cm=_G["c"..m]
function cm.initial_effect(c)
	rshr.Set(c)
	rshr.DiscardFun(c,m,"th",rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
	rshr.GraveFun(c,m,"th",cm.op)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TUNER)
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")	
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function cm.op(e,tp)
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		rsof.SelectHint(tp,"th")
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end 
	end
end