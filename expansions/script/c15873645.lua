--心之怪盗团-武见妙的私人医院
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873645
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c) 
	local e1=rsef.ACT(c)
	local e2=rsef.FTO(c,EVENT_CUSTOM+m,{m,0},{1,m},"rec","de,ptg",LOCATION_SZONE,cm.reccon,nil,cm.rectg,cm.recop)
	local e3=rsef.QO(c,nil,{m,1},{1,m},nil,nil,LOCATION_SZONE,rscon.phbp,nil,rstg.target(rsop.list(rscf.FilterFaceUp(rsphh.set),nil,LOCATION_MZONE)),cm.op)
	if not cm.check then
		cm.check={[0]=Duel.GetLP(0),[1]=Duel.GetLP(1)}
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_ADJUST)
		ge:SetOperation(cm.adjustop)
		Duel.RegisterEffect(ge,tp)
	end
end
function cm.op(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local g=Duel.GetMatchingGroup(rscf.FilterFaceUp(rsphh.set),tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=rsef.SV_INDESTRUCTABLE({c,tc},"ct",cm.val,nil,rsreset.est)
	end
end
function cm.val(e,re,r,rp)
	return r&REASON_BATTLE ~=0
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(rscf.FilterFaceUp(rsphh.set),tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500+ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500+ct*500)
end
function cm.recop(e,tp)
	if not aux.ExceptThisCard(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.GetMatchingGroupCount(rscf.FilterFaceUp(rsphh.set),p,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Recover(p,500+ct*500,REASON_EFFECT)
end
function cm.adjustop(e,tp)
	for i=0,1 do
		local lp,blp=Duel.GetLP(i),cm.check[i]
		if lp~=blp then
			Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+m,nil,nil,i,i,lp-blp)
			cm.check[i]=lp
		end
	end
end
