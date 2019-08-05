--谐律 轻盈电音
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=18010001
local cm=_G["c"..m]
if not rsv.HarmonicRhythm then
	rsv.HarmonicRhythm={}
	rshr=rsv.HarmonicRhythm
function rshr.Set(c)
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		local mt=getmetatable(c)
		mt.rssetcode="HarmonicRhythm"
	end
end
function rshr.IsSet(c)
	return c:CheckSetCard("HarmonicRhythm")
end
function rshr.DiscardFun(c,code,cate,tg,op)
	local e1=rsef.I(c,{m,0},{1,code},cate,nil,LOCATION_HAND,nil,rscost.cost({Card.IsDiscardable,nil},{rshr.cfilter,{"dish",rshr.disfun},LOCATION_HAND,0,1,1,c}),tg,op)
	return e1
end
function rshr.disfun(g,e,tp)
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function rshr.cfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_TUNER)
end
function rshr.GraveFun(c,code,cate,extraop)
	local e1=rsef.FTO(c,EVENT_TO_GRAVE,{m,1},{1,code},{cate,"sp"},"de",LOCATION_GRAVE,rshr.spcon,nil,rsop.target(rshr.spfilter,"sp"),rshr.spop(extraop))
	return e1
end
function rshr.spcon(e,tp,eg)
	local c=e:GetHandler()
	return not eg:IsContains(c) and eg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function rshr.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function rshr.spop(extraop)
	return function(e,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(rshr.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local c=rscf.GetRelationThisCard(e)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c or rssf.SpecialSummon(c)<=0 then return end
		if extraop then
			extraop(e,tp)
		end
	end
end
function rshr.splimit(e,c)
	return not c:IsType(TYPE_TUNER)
end
---------------
end
---------------
if cm then
function cm.initial_effect(c)
	rshr.Set(c)
	rshr.DiscardFun(c,m,"th",rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	rshr.GraveFun(c,m,nil,cm.op)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rshr.IsSet(c)
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")	
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.op(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TUNER)
	if #g>0 and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,g) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		rsof.SelectHint(tp,"sp")
		local sc=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil,g):GetFirst()
		Duel.SynchroSummon(tp,sc,nil,g)
	end
end
---------------
end
