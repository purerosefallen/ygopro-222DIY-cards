--折幸 纯苍
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=88946423
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	rscf.SetSummonCondition(c,false,cm.sumval)
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(Card.IsSetCard,0x960),aux.NonTuner(nil))
	local e1,e2=rsef.FV_UPDATE(c,"atk,def",cm.val,nil,{0,LOCATION_MZONE })
	local e3=rsef.I(c,{m,0},nil,"tg","tg",LOCATION_MZONE,nil,rscost.cost(Card.IsReleasable,"res"),rstg.target(cm.tgfilter,"tg",LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c),cm.tgop)
	local e4=rsef.RegisterClone(c,e3,"type",EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O,"code",EVENT_PRE_DAMAGE_CALCULATE)
end
function cm.sumval(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or st&SUMMON_TYPE_SYNCHRO ==SUMMON_TYPE_SYNCHRO or se:GetHandler():IsSetCard(0x960)
end
function cm.val(e,c)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)*-200
end
function cm.tgfilter(c,e,tp)
	return c:IsAbleToGrave() and not e:GetHandler():GetEquipGroup():IsContains(c)
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.SendtoGrave(tc,REASON_EFFECT) end
end