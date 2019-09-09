--恶梦启示 虚伪
if not pcall(function() require("expansions/script/c33330400") end) then require("script/c33330400") end
local m=33330402
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e3=rsnm.SummonFun(c,m)   
	local e4=rsnm.FilpFun(c,m,"eq",nil,rsop.target({cm.eqfilter,"eq",0,LOCATION_MZONE },{cm.cfilter,nil,LOCATION_MZONE }),cm.op)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4552) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.eqfilter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	if #g<=0 then return end
	rsof.SelectHint(tp,"eq")
	local tg=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	if #tg<=0 then return end
	rsof.SelectHint(tp,HINTMSG_SELF)
	local tg2=g:Select(tp,1,1,nil)
	Duel.HintSelection(tg)
	Duel.HintSelection(tg2)
	local tc=tg:GetFirst()
	local tc2=tg2:GetFirst()
	if not rsop.eqop(e,tc,tc2) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(tc:GetTextAttack())
	tc:RegisterEffect(e1)
end