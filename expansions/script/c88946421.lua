--折幸 暗歌
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=88946421
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	rscf.SetSummonCondition(c,false,cm.sumval)
	aux.AddXyzProcedure(c,nil,4,2,cm.ovfilter,aux.Stringid(m,0))
	local e1=rsef.I(c,{m,1},{1,m},"se,th",nil,LOCATION_MZONE,nil,rscost.cost(Card.IsReleasable,"res"),rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e2=rsef.I(c,{m,2},{1,m+100},"atk,def","tg",LOCATION_GRAVE,nil,rscost.cost(Card.IsAbleToExtraAsCost,"te"),rstg.target(cm.ovfilter,nil,LOCATION_MZONE),cm.atkop)
end
function cm.sumval(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or st&SUMMON_TYPE_FUSION ==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x960)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x960) 
end
function cm.thfilter(c)
	return c:IsSetCard(0x960) and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.atkop(e,tp)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local maxg,maxatk=g:GetMaxGroup(Card.GetAttack)
	local atk=tc:GetBaseAttack()+maxatk
	local e1,e2=rsef.SV_SET({e:GetHandler(),tc},"atkf,deff",atk,nil,rsreset.est_pend)
end
