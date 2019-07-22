--折幸 智语
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=88946426
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"se,th",nil,nil,nil,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e2=rsef.QO(c,nil,{m,2},nil,"td",nil,LOCATION_GRAVE+LOCATION_REMOVED,nil,rscost.cost(Card.IsAbleToDeckAsCost,"td"),rstg.target(rsop.list(cm.tdfilter,"td",LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c)),cm.tdop)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x960)
end
function cm.handcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.b1(c)
	return c:IsAbleToHand()
end
function cm.b2(c)
	return c:IsSSetable() and c:IsType(TYPE_TRAP)
end
function cm.thfilter(c,e,tp)
	if not c:IsSetCard(0x960) then return false end
	return cm.b1(c) or cm.b2(c)
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,HINTMSG_SELF)	
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local b1=cm.b1(tc)
	local b2=cm.b2(tc)
	local op=rsof.SelectOption(tp,b1,{m,0},b2,{m,1},true)
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.tdfilter(c)
	return c:IsSetCard(0x960) and c:IsAbleToDeck()
end
function cm.tdop(e,tp)
	rsof.SelectHint(tp,"td")
	local tg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end