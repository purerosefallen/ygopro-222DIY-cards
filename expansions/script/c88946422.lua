--折幸 紫华
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=88946422
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	rscf.SetSummonCondition(c,false,cm.sumval)
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x960),2,true)
	--local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"th","tg",nil,nil,rstg.target(cm.thfilter,"th",LOCATION_GRAVE),cm.thop)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"th","tg",nil,nil,rstg.target(cm.setfilter,nil,LOCATION_GRAVE),cm.setop)
	local e2=rsef.QO(c,nil,{m,1},nil,nil,nil,LOCATION_MZONE,nil,rscost.cost(Card.IsReleasable,"res"),nil,cm.imop)
	local e3=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.spcon,cm.spop)
end
function cm.sumval(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or st&SUMMON_TYPE_FUSION ==SUMMON_TYPE_FUSION or se:GetHandler():IsSetCard(0x960)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x960) and c:IsType(TYPE_TRAP)
end
function cm.thop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
function cm.setfilter(c)
	return c:IsSSetable() and c:IsSetCard(0x960) and c:IsType(TYPE_TRAP)
end
function cm.setop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and tc:IsSSetable() then 
		Duel.SSet(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.imop(e,tp)
	local e1=rsef.FV_IMMUNE_EFFECT({e:GetHandler(),tp},cm.val,aux.TargetBoolFunction(Card.IsSetCard,0x960),{LOCATION_MZONE,0},nil,rsreset.pend)
	e1:SetOwnerPlayer(tp)
end
function cm.val(e,re)
	return re:GetHandlerPlayer()~=e:GetOwnerPlayer() and re:IsHasType(TYPE_MONSTER)
end
function cm.spfilter(c,tp)
	return c:IsSetCard(0x960) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,cm.spfilter,1,nil,tp)
end
function cm.spop(e,tp)
	local g=Duel.SelectReleaseGroup(tp,cm.spfilter,1,1,nil,tp)
	Duel.Release(g,REASON_EFFECT)
end