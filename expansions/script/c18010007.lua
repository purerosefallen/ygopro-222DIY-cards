--调谐律法
if not pcall(function() require("expansions/script/c18010001") end) then require("script/c18010001") end
local m=18010007
local cm=_G["c"..m]
function cm.initial_effect(c)
	rshr.Set(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1})
	--local e2=rsef.I(c,{m,0},1,"se,th",nil,LOCATION_FZONE,nil,rscost.cost(cm.cfilter,"dish",LOCATION_HAND),cm.thtg,cm.thop)
	local e2=rsef.I(c,{m,0},1,"se,th,ga",nil,LOCATION_FZONE,nil,rscost.cost(cm.cfilter,"dish",LOCATION_HAND),rsop.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop2)
	local e3=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,1},nil,"dr,td","de",LOCATION_FZONE,nil,nil,cm.drtg,cm.drop)
end
function cm.cfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_TUNER)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rshr.IsSet(c) and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.thop(e,tp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<=1 then return end
	rsof.SelectHint(tp,"th")
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.thfilter2(c,tc)
	return c:IsType(TYPE_TUNER) and c:IsAbleToHand() and c:IsAttack(tc:GetAttack()) and c:IsDefense(tc:GetDefense()) and c:IsAttribute(tc:GetAttribute()) and c:IsLevel(tc:GetLevel())
end
function cm.thop2(e,tp)
	rsof.SelectHint(tp,"th")
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,nil,tc)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			rsof.SelectHint(tp,"th")
			local tg=g:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	end
end
function cm.cfilter2(c)
	local mat=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and #mat>0 and mat:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function cm.matcheck(eg)
	local dct=0
	for tc in aux.Next(eg) do
		local mat=tc:GetMaterial()
		if tc:IsSummonType(SUMMON_TYPE_SYNCHRO) and #mat>0 then 
			local tct=mat:FilterCount(Card.IsType,nil,TYPE_TUNER)
			dct=dct+tct
		end
	end
	return dct
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dct=cm.matcheck(eg)
	if chk==0 then return dct>0 and Duel.IsPlayerCanDraw(tp,dct) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,2,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		rsof.SelectHint(tp,"td")
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,2,2,nil)
		if #g==2 and Duel.SendtoDeck(g,nil,0,REASON_EFFECT)==2 then 
			Duel.SortDecktop(tp,tp,2)
		end
	end
end