--谐律 热烈打击
if not pcall(function() require("expansions/script/c18010001") end) then require("script/c18010001") end
local m=18010002
local cm=_G["c"..m]
function cm.initial_effect(c)
	rshr.Set(c)
	rshr.DiscardFun(c,m,"sp",rsop.target(cm.spfilter,"sp",LOCATION_DECK),cm.spop)
	rshr.GraveFun(c,m,"th",cm.op)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and rshr.IsSet(c)
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")	
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		rssf.SpecialSummon(g)
	end
end
function cm.thfilter(c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local att=0
	for tc in aux.Next(g) do
		local att2=tc:GetAttribute()
		if att2 then
			att=att|att2
		end
	end
	return c:IsType(TYPE_TUNER) and c:IsAbleToHand() and c:IsAttribute(att)
end
function cm.op(e,tp)
	if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		rsof.SelectHint(tp,"th")
		local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end