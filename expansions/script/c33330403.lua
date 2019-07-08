--恶梦启示 怀疑
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330403
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e3=rsnm.SummonFun(c,m)   
	local e4=rsnm.FilpFun(c,m,"rm",cm.con,nil,cm.op)
end
function cm.con(e,tp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
end 
function cm.op(e,tp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	local opt=Duel.AnnounceType(tp)
	Duel.ConfirmDecktop(1-tp,1)
	if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
		local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #hg<=0 then return end
		Duel.ConfirmCards(tp,hg)
		if hg:IsExists(cm.rmfilter,1,nil,opt) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			rsof.SelectHint(tp,"rm")
			local rg=hg:FilterSelect(tp,cm.rmfilter,1,2,nil,opt)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end
function cm.rmfilter(c,opt)
	return c:IsAbleToRemove() and ((opt==0 and c:IsType(TYPE_MONSTER)) or (opt==1 and c:IsType(TYPE_SPELL)) or (opt==2 and c:IsType(TYPE_TRAP)))
end