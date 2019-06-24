--人格面具-赛特
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873647
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"des","de",nil,cm.descost,rstg.target(rsop.list(aux.TRUE,"des",0,LOCATION_ONFIELD)),cm.desop)
	local e8=rsphh.EndPhaseFun(c,15873611)
	--necro valley
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_NECRO_VALLEY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetCondition(cm.contp)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,LOCATION_GRAVE)
	e3:SetCondition(cm.conntp)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_NECRO_VALLEY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCondition(cm.contp)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetTargetRange(0,1)
	e5:SetCondition(cm.conntp)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_NECRO_VALLEY_IM)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(1,0)
	c:RegisterEffect(e7)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.desop(e,tp)
	local c=e:GetHandler()
	rsof.SelectHint(tp,"des")
	local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local dg=rsgf.GetAdjacentGroup(tc)
	dg:AddCard(tc)
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.contp(e)
	return not Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)
end
function cm.conntp(e)
	return not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)
end
function cm.disfilter(c)
	return c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function cm.discheck(ev,category,re,im0,im1)
	local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,category)
	if not ex then return false end
	if v==LOCATION_GRAVE and ct>0 then
		if p==0 then return im0
		elseif p==1 then return im1
		elseif p==PLAYER_ALL then return im0 and im1
		end
	end
	if tg and tg:GetCount()>0 then
		return tg:IsExists(cm.disfilter,1,nil)
	end
	return false
end
function cm.discheck2(ev,category)
	local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,category)
	if not ex then return false end
	if v==LOCATION_GRAVE and ct>0 and tg then
		return tg:IsExists(cm.disfilter,1,nil)
	end
	return false
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not Duel.IsChainDisablable(ev) or tc:IsHasEffect(EFFECT_NECRO_VALLEY_IM) then return end
	local res=false
	local im0=not Duel.IsPlayerAffectedByEffect(0,EFFECT_NECRO_VALLEY_IM)
	local im1=not Duel.IsPlayerAffectedByEffect(1,EFFECT_NECRO_VALLEY_IM)
	if not res and cm.discheck(ev,CATEGORY_SPECIAL_SUMMON,re,im0,im1) then res=true end
	if not res and cm.discheck(ev,CATEGORY_TOHAND,re,im0,im1) then res=true end
	if not res and cm.discheck(ev,CATEGORY_TODECK,re,im0,im1) then res=true end
	if not res and cm.discheck(ev,CATEGORY_TOEXTRA,re,im0,im1) then res=true end
	if not res and cm.discheck(ev,CATEGORY_LEAVE_GRAVE,re,im0,im1) then res=true end
	if not res and cm.discheck2(ev,CATEGORY_REMOVE) then res=true end
	if res then Duel.NegateEffect(ev) end
end
