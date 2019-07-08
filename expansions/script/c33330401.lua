--恶梦启示 偏见
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330401
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e3=rsnm.SummonFun(c,m)   
	local e4=rsnm.FilpFun(c,m,"atk",cm.con,nil,cm.op)
end
function cm.con(e,tp)
	return Duel.IsExistingMatchingCard(cm.getcount,tp,0,LOCATION_MZONE,1,nil,true)
end
function cm.op(e,tp)
	local g=Duel.GetMatchingGroup(cm.getcount,tp,0,LOCATION_MZONE,nil)
	if #g<=0 then return end
	for tc in aux.Next(g) do
		local atk=cm.getcount(tc)
		local e1=rsef.SV_SET({e:GetHandler(),tc},"atkf",atk*200,nil,rsreset.est)
	end
end
function cm.getcount(c,isreturn)
	local ct=0
	if c:IsLevelAbove(1) then ct=c:GetLevel()
	elseif c:IsRankAbove(1) then ct=c:GetRank()
	elseif c:IsLinkAbove(1) then ct=c:GetLink()
	end
	if isreturn then return ct>0 end
	return ct
end