--恶梦启示录
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33330400
local cm=_G["c"..m]
if not rsv.Nightmare then
	rsv.Nightmare={}
	rsnm=rsv.Nightmare
function rsnm.SummonFun(c,code,type2,isgrave)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e0)
	if type2 then
		local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,rsnm.spcon2,rsnm.spop2)
		local lab=not isgrave and LOCATION_ONFIELD or LOCATION_GRAVE 
		e1:SetLabel(lab)
		return e1
	end
	local e1=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,rsnm.spcon,rsnm.spop)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,rsnm.counterfilter)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCost(rsnm.limcost)
	e2:SetOperation(rsnm.limop)
	c:RegisterEffect(e2)
	local e3=rsef.STO(c,EVENT_TO_GRAVE,{m,0},{1,code},"se,th","de,dsp",rsnm.thcon,nil,rsop.target(rsnm.thfilter,"th",LOCATION_DECK),rsnm.thop)
	return e1,e2,e3
end
function rsnm.counterfilter(c)
	if c:GetSummonLocation()&LOCATION_HAND+LOCATION_DECK ==0 then return true end
	return c:IsSetCard(0x4552) 
end
function rsnm.spcfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeckAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function rsnm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(rsnm.spcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
end
function rsnm.spop(e,tp)
	rsof.SelectHint(tp,"td")
	local tg=Duel.SelectMatchingCard(tp,rsnm.spcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SendtoDeck(tg,nil,2,REASON_COST)
end
function rsnm.spcfilter2(c,tp)
	return c:IsSetCard(0x4552) and c:IsAbleToDeckAsCost() and Duel.GetMZoneCount(tp,c,tp)>0
end
function rsnm.spcfilter3(c,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function rsnm.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(rsnm.spcfilter2,tp,LOCATION_HAND+e:GetLabel(),0,nil)
	return g:CheckSubGroup(rsnm.spcfilter3,2,2,tp)
end
function rsnm.cffilter(c)
	return c:IsFacedown() or c:IsLocation(LOCATION_HAND)
end
function rsnm.spop2(e,tp)
	local g=Duel.GetMatchingGroup(rsnm.spcfilter2,tp,LOCATION_HAND+e:GetLabel(),0,nil)
	rsof.SelectHint(tp,"td")
	local tg=g:SelectSubGroup(tp,rsnm.spcfilter3,false,2,2,tp)
	local cg=tg:Filter(rsnm.cffilter,nil)
	if #cg>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(tg,nil,2,REASON_COST)
end
function rsnm.limcost(e,c,tp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
end
function rsnm.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(rsnm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function rsnm.splimit(e,c)
	if c:IsLocation(LOCATION_HAND+LOCATION_DECK) then return not c:IsSetCard(0x4552)
	else return false
	end
end
function rsnm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function rsnm.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x4552)
end
function rsnm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,rsnm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function rsnm.FilpFun(c,code,cate,con,tg,op,ctlimit)
	local limit=ctlimit and {1,code} or nil
	local e1=rsef.STO(c,EVENT_FLIP,{code,0},limit,cate,"de",con,nil,tg,op)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		local mt=getmetatable(c)
		mt.flip_effect=e1
	end
	return e1
end
function rsnm.FilpFun2(c,code,cate,con,tg,op)
	local e1=rsef.STO(c,EVENT_FLIP,{code,0},nil,cate,"de,dsp",con,nil,tg,op)
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		local mt=getmetatable(c)
		mt.flip_effect=e1
	end
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_SPSUMMON_SUCCESS)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	return e1,e2
end
--------------
end
--------------
if cm then
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,EVENT_CHAINING,{m,0},1,nil,nil,LOCATION_SZONE,cm.con,rscost.reglabel(100),cm.tg,cm.op)
	local e3=rsef.FTO(c,EVENT_ATTACK_ANNOUNCE,{m,1},nil,"pos",nil,LOCATION_SZONE,cm.poscon,nil,rsop.target(cm.posfilter,"pos",LOCATION_MZONE,0,true),cm.posop)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	rsof.SelectHint(tp,"pos")
	local tc=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,true)
	e:SetLabelObject(tc)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local tc=e:GetLabelObject()
	if not tc:IsSetCard(0x4552) then return end
	local e1=rsef.SV_IMMUNE_EFFECT(c,cm.val,nil,rsreset.est_pend)
	e1:SetOwnerPlayer(tp)
	local te=tc.flip_effect
	if not te then return end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end	
end
function cm.val(e,re)
	return re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function cm.posfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4552)
end
function cm.posop(e,tp)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local sg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_MZONE,0,nil)
		Duel.ShuffleSetCard(sg)
		rsof.SelectHint(1-tp,HINTMSG_OPPO)
		local ac=Duel.SelectMatchingCard(1-tp,nil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.ChangeAttackTarget(ac)
	end
end
function cm.sfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
--------------
end
