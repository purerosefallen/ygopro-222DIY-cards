--恶梦启示 绝望
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330405
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e3=rsnm.SummonFun(c,m)   
	local e4=rsnm.FilpFun(c,m,"pos,dr",cm.con,nil,cm.op,true)
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tffilter(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
	g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.BreakEffect()
	end
	for i=0,1 do
		local tg=Duel.GetMatchingGroup(cm.tffilter,i,LOCATION_MZONE,0,nil,e)
		if #tg>0 then 
			local ft=Duel.GetLocationCount(i,LOCATION_SZONE)
			local ct=math.min(#tg,ft)
			rsof.SelectHint(i,{m,1})
			local sg=tg:Select(i,ct,ct,nil)
			Duel.HintSelection(sg)
			for tc in aux.Next(sg) do
				if Duel.MoveToField(tc,i,i,LOCATION_SZONE,POS_FACEUP,true) then 
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
		tg=Duel.GetMatchingGroup(Card.IsFaceup,i,LOCATION_MZONE,0,nil)
		if #tg>0 then
			--Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.flipcon)
	e1:SetOperation(cm.flipop)
	Duel.RegisterEffect(e1,tp)
end
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_MZONE,1,nil)
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	Duel.Draw(1-tp,ct,REASON_EFFECT)
end