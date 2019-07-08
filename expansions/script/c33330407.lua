--恶梦启示 卑劣
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330407
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e3=rsnm.SummonFun(c,m)   
	local e4=rsnm.FilpFun(c,m,"atk",nil,rsop.target(cm.cfilter,nil,0,LOCATION_MZONE),cm.op)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	rsof.SelectHint(tp,HINTMSG_OPPO)
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if #tg<=0 then return end
	Duel.HintSelection(tg)
	local atk=tg:GetFirst():GetAttack()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=rsef.SV_UPDATE({c,tc},"atk",-atk,nil,rsreset.est_pend,"cd")
	end
end