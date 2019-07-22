--恶梦启示 怨恨
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330410
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,2)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},nil,"de,dsp",nil,nil,rsop.target(cm.tfilter,nil,LOCATION_GRAVE+LOCATION_REMOVED,0,2),cm.op)
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"se,th",nil,LOCATION_MZONE,nil,rscost.cost(cm.cfilter,{"pos",cm.fun},LOCATION_MZONE),rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.thop)
	--cannot be target/indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
end
function cm.lfilter(c)
	return c:IsLinkRace(RACE_FIEND) --and not c:IsSummonableCard()
end
function cm.tfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function cm.indcon(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end
function cm.op(e,tp)
	local c=e:GetHandler()
	rsof.SelectHint(tp,HINTMSG_SELF)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	if #tg<=0 then return end
	Duel.HintSelection(tg)
	for tc in aux.Next(tg) do
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then 
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1,true)
		end
	end
end
function cm.cfilter(c)
	return (c:IsFacedown() and c:IsCanChangePosition()) or (c:IsFaceup() and c:IsCanTurnSet()) 
end
function cm.fun(g,e,tp)
	local tc=g:GetFirst()
	if tc:IsFaceup() then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	else Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x4552)
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end 
end