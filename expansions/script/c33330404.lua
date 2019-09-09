--恶梦启示 抑郁
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330404
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e3=rsnm.SummonFun(c,m)   
	local e4=rsnm.FilpFun(c,m,"th,sp",nil,rsop.target({Card.IsAbleToHand,"th",LOCATION_MZONE },{cm.spfilter,"sp",LOCATION_HAND }),cm.op,true)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6552) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,2,nil)
	if #tg<=0 then return end
	Duel.HintSelection(tg)
	local ct=Duel.SendtoHand(tg,nil,REASON_EFFECT)
	if ct<=0 then return end
	ct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),ct)
	if ct<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,ct,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,sg)
	end
end