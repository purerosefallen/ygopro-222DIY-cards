--咒念树
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33330413
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),true) 
	rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.con,cm.op)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp",nil,LOCATION_MZONE,nil,rscost.cost(cm.cfilter,"res",LOCATION_ONFIELD),rsop.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	local e2=rsef.SV_IMMUNE_EFFECT(c,rsval.imes,rscon.excard(Card.IsFacedown))
end 
function cm.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.resfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.resfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER ~=0 and c:IsReleasable()
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"res")
	local g=Duel.SelectMatchingCard(tp,cm.resfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.cfilter(c,e,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) 
end
function cm.spop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
