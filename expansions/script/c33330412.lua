--恶梦启示 虚荣
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330412
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsnm.SummonFun(c,m,true,true)   
	local e2,e3=rsnm.FilpFun2(c,m,"atk",nil,rsop.target(Card.IsCanTurnSet,"pos",LOCATION_MZONE),cm.op)
	local e4=rsef.STO(c,EVENT_TO_GRAVE,{m,1},{1,m},"sp","de,dsp",nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_DECK),cm.spop)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	rsof.SelectHint(tp,"pos")
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc or Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)<=0 then return end
	local e1=rsef.FV_CANNOT_BE_TARGET({c,tp},"effect",aux.tgoval,aux.TargetBoolFunction(Card.IsFacedown),{LOCATION_MZONE,0},nil,rsreset.pend)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x4552) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and not c:IsCode(m)
end
function cm.spop(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,sg)
	end
end