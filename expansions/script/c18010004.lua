--谐律 稳重吹管
if not pcall(function() require("expansions/script/c18010001") end) then require("script/c18010001") end
local m=18010004
local cm=_G["c"..m]
function cm.initial_effect(c)
	rshr.Set(c)
	rshr.DiscardFun(c,m,"sp",rsop.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	rshr.GraveFun(c,m,nil,cm.op)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and rshr.IsSet(c)
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")	
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		rssf.SpecialSummon(g)
	end
end
function cm.op(e,tp)
	if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		rsof.SelectHint(tp,"sp")
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		if #g>0 then
			rssf.SpecialSummon(g)
		end 
	end
end