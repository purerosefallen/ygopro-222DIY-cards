--恶梦启示 急躁
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330411
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsnm.SummonFun(c,m,true,false,true)   
	local e2,e3=rsnm.FilpFun2(c,m,"atk",nil,rsop.target2(cm.fun,{cm.posfilter,"pos",LOCATION_MZONE }),cm.op)
	local e4=rsef.QO(c,nil,{m,1},{1,m},"sp",nil,LOCATION_MZONE,nil,rscost.cost(cm.resfilter,"res",LOCATION_MZONE),rsop.target(cm.spfilter,"sp",LOCATION_HAND+LOCATION_GRAVE),cm.spop)
end
function cm.fun(g,e,tp)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.posfilter(c)
	return c:IsDefensePos() and c:IsCanChangePosition()
end
function cm.cfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"pos")
	local tc=Duel.SelectMatchingCard(tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(rsgf.Mix2(tc))
	if Duel.ChangePosition(tc,POS_FACEUP_ATTACK)<=0 then return end
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	Duel.BreakEffect()
	local e1=rsef.SV_UPDATE({e:GetHandler(),tc},"atk",ct*500,nil,rsreset.est,"cd")
end
function cm.resfilter(c,e,tp)
	return c:IsReleasable() and c:IsFaceup() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x6552) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.spop(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,sg)
	end
end