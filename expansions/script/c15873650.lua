--人格面具-路西法
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873650
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	local e1=rsef.FV_LIMIT_PLAYER(c,"act",cm.val,nil,{0,1})
	local e2=rsef.I(c,{m,0},{1,m},"des,dis",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.cfilter,"des",0,LOCATION_MZONE),cm.desop)
	local e4=rsphh.EndPhaseFun(c,15873611)
end
function cm.val(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_DARK) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end 
function cm.desop(e,tp)
	local c=e:GetHandler()
	rsof.SelectHint(tp,"des")
	local dg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if #dg<=0 then return end
	Duel.HintSelection(dg)
	local tc=dg:GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(cm.distg)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabel(tc:GetOriginalCode())
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		Duel.RegisterEffect(e2,tp)  
	end
end
function cm.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end