--恶梦启示 诋毁
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330408
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e3=rsnm.SummonFun(c,m)   
	local e4=rsnm.FilpFun(c,m,"rm",nil,rsop.target(cm.rmfilter,"rm",0,LOCATION_GRAVE+LOCATION_EXTRA),cm.op,true)
end
function cm.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function cm.op(e,tp)
	rsof.SelectHint(tp,"rm")
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.rmfilter),tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,1,nil):GetFirst()
	if not tc or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_REMOVED) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCountLimit(1)
	e1:SetReset(rsreset.pend,2)
	e1:SetCondition(cm.chcon)
	e1:SetOperation(cm.chop)
	e1:SetLabelObject(tc)
	Duel.RegisterEffect(e1,tp)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabelObject():GetOriginalCodeRule())
end
function cm.chop(e,tp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.changeop)
end
function cm.changeop(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)	
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end 