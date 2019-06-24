--人格面具-伊斯塔
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873648
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},nil,"de,dsp")
	e1:SetOperation(cm.op)
	local e2=rsef.QO_NEGATE(c,"neg",{1,m},"des",nil,cm.negcon) 
	local e3=rsphh.EndPhaseFun(c,15873611)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-#tg>0
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1=rsef.FV_INDESTRUCTABLE({c,tp},"all",nil,nil,{0xff,0xff},nil,rsreset.pend)
	local e2=rsef.FV_REDIRECT(c,"tg",LOCATION_REMOVED,nil,{0xff,0xff},nil,rsreset.pend)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e3=rsef.FC(c,EVENT_PHASE+PHASE_END,{m,1},1,"cd",LOCATION_MZONE,nil,cm.rmop,rsreset.est_pend)
	end
end
function cm.rmop(e,tp)
	local c=e:GetHandler()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 then
		local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if ct>0 then
			Duel.Recover(tp,ct*500,REASON_EFFECT,true)
			Duel.Recover(1-tp,ct*500,REASON_EFFECT,true)
			Duel.RDComplete()
		end
	end
end