--折幸 压制
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=88946425
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,{1,m,1},"dis,sp","tg",cm.discon,nil,rstg.target(cm.disfilter,"dis",LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE),cm.disop)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function cm.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x960)
end
function cm.discon(e,tp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.disfilter(c,e)
	return aux.disfilter1(c) and c~=e:GetHandler()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x960) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0) or (c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function cm.disop(e,tp)
	local c=e:GetHandler()
	local tc=rscf.GetTargetCard(aux.disfilter1)
	local e1=rsef.FV_LIMIT_PLAYER({c,tp},"sum,sp",nil,cm.spval,{1,0},nil,{rsreset.pend,2})
	if not tc then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1,e2=rsef.SV_LIMIT({c,tc},"dis,dise",nil,nil,rsreset.est_pend)
	if tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	if #g<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.BreakEffect()
	rsof.SelectHint(tp,"sp")
	local sg=g:Select(tp,1,1,nil)
	rssf.SpecialSummon(sg)
end
function cm.spval(e,c)
	return not c:IsSetCard(0x960)
end