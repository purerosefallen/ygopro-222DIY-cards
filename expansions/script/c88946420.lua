--折幸 源舞
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=88946420
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp","tg",LOCATION_HAND+LOCATION_GRAVE,nil,nil,rstg.target3(cm.fun,{rscf.FilterFaceUp(Card.IsSetCard,0x960),nil,LOCATION_ONFIELD },rsop.list(cm.spfilter,"sp",true)),cm.spop)
	local e3=rsef.STO(c,EVENT_TO_GRAVE,{m,0},{1,m+100},"atk,def","de,dsp",nil,nil,nil,cm.atkop)
	--[[local e2=rsef.QO(c,nil,{m,1},{1,m+100},nil,nil,LOCATION_MZONE,nil,rscost.cost(Card.IsReleasable,"res"),rstg.target(rsop.list(cm.setfilter,nil,LOCATION_DECK)),cm.setop)
	if not rsef.actlimiteffect then
		rsef.actlimiteffect={}
	end
	rsef.actlimiteffect[e2]=true--]]
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x960))
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function cm.fun(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.setfilter(c)
	return c:IsSetCard(0x960) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function cm.setop(e,tp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	rsof.SelectHint(tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SSet(tp,tc)   
	Duel.ConfirmCards(1-tp,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=rsef.FV_LIMIT_PLAYER({c,tp},"act",cm.val,nil,{1,1},nil,{rsreset.pend,2})
end
function cm.val(e,re,tp)
	return rsef.actlimiteffect[re]
end