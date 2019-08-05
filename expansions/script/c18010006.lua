--谐律调 优美和声
if not pcall(function() require("expansions/script/c18010001") end) then require("script/c18010001") end
local m=18010006
local cm=_G["c"..m]
function cm.initial_effect(c)
	rshr.Set(c)
	c:EnableReviveLimit()
	rscf.AddSynchroMixProcedure(c,aux.Tuner(Card.IsLevel,3),nil,nil,aux.Tuner(Card.IsLevel,3),1,1)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"th","de,dsp",rscon.sumtype("syn"),nil,rsop.target({cm.thfilter,"th",LOCATION_GRAVE },{cm.thfilter,"th",0,LOCATION_GRAVE }),cm.op) 
	local e2=rsef.FTO(c,EVENT_TO_GRAVE,{m,1},1,"se,th","de",LOCATION_MZONE,cm.thcon,nil,rsop.target(cm.thfilter2,"th",LOCATION_DECK),cm.thop)
	local e3=rsef.QO(c,nil,{m,2},1,"sp",nil,LOCATION_MZONE,cm.syncon,nil,rsop.target(cm.synfilter,"sp",LOCATION_EXTRA),cm.synop)
end
function cm.thfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function cm.op(e,tp)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter),tp,0,LOCATION_GRAVE,nil)
	if #g1<=0 or #g2<=0 then return end
	rsof.SelectHint(tp,"th")
	local tg1=g1:Select(tp,1,1,nil)
	rsof.SelectHint(tp,"th")
	local tg2=g2:Select(tp,1,1,nil)   
	tg1:Merge(tg2)
	Duel.HintSelection(tg1)
	Duel.SendtoHand(tg1,tp,REASON_EFFECT)
end
function cm.tdcon(e,tp,eg)
	return eg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function cm.cfilter(c,lv)
	return c:IsType(TYPE_TUNER) and c:IsLevel(lv)
end
function cm.thfilter(c,e,tp,eg)
	return c:IsAbleToHand() and c:IsType(TYPE_TUNER) and eg and eg:IsExists(cm.cfilter,1,nil,c:GetLevel())
end
function cm.thop(e,tp,eg)
	rsof.SelectHint(tp,"th")
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.syncon(e,tp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.synfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TUNER)
	return #g>0 and c:IsSynchroSummonable(nil,g)
end
function cm.synop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TUNER)
	rsof.SelectHint(tp,"sp")
	local sc=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil,g):GetFirst()
	if sc then
		Duel.SynchroSummon(tp,sc,nil,g)
	end
end