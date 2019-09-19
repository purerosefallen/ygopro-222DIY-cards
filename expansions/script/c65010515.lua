--URBEX HINDER-暴食者
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010515
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:AddLinkProcedure(nil,2,3,cm.gf)
	local e1=rsef.QO(c,nil,{m,1},{1,m},"sp",nil,LOCATION_MZONE,rscon.phmp,nil,rsop.target2(cm.fun,cm.lfilter,"sp",LOCATION_EXTRA),cm.spop)
end
cm.rssetcode=="URBEX"
function cm.gf(g)
	return g:IsExists(rscf.CheckSetCard,1,nil,"URBEX")
end
function cm.lfilter(c,e,tp)
	local rc=e:GetHandler()
	local ct=rc:GetMutualLinkedGroupCount()
	local g=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return g:CheckSubGroup(cm.gfilter,1,99,c,rc,tp,ct)
end
function cm.gfilter(g,lc,mc,tp,ct)
	return g:IsContains(mc) and g:FilterCount(Card.IsControler,nil,1-tp)<=ct and lc:IsLinkSummonable(g,nil,#g,#g) and lc:CheckSetCard("URBEX")
end
function cm.mfilter(c,tp)
	return c:IsControler(tp) or (c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_EXTRA)
end
function cm.fun(g,e,tp)
	if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.lfilter2(c,g,rc,tp,ct)
	return g:CheckSubGroup(cm.gfilter,1,99,c,rc,tp,ct)
end
function cm.spop(e,tp)
	local c=rscf.GetRelationThisCard(e)
	if not c then return end
	local ct=e:GetLabel()==1 and c:GetMutualLinkedGroupCount() or 0
	local g=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	rsof.SelectHint(tp,"sp")
	local lc=Duel.SelectMatchingCard(tp,cm.lfilter2,tp,LOCATION_EXTRA,0,1,1,nil,g,c,tp,ct):GetFirst()
	if not lc then return end
	rsof.SelectHint(tp,HINTMSG_LMATERIAL)
	local mg=g:SelectSubGroup(tp,cm.gfilter,false,1,99,lc,c,tp,ct)
	Duel.LinkSummon(tp,lc,mg)
end