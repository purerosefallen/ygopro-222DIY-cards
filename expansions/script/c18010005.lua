--谐律调 崇高奏鸣
if not pcall(function() require("expansions/script/c18010001") end) then require("script/c18010001") end
local m=18010005
local cm=_G["c"..m]
function cm.initial_effect(c)
	rshr.Set(c)
	rscf.AddSynchroMixProcedure_CheckMaterial(c,aux.Tuner(nil),nil,nil,aux.Tuner(nil),1,99,cm.checkfun)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"td","de,dsp",rscon.sumtype("syn"),nil,cm.tg,cm.op)
	local e2=rsef.FTO(c,EVENT_TO_GRAVE,{m,1},1,"td","de",LOCATION_MZONE,cm.tdcon,nil,rsop.target(Card.IsAbleToDeck,"td",LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE),cm.tdop)
	--local e3=rsef.STO(c,EVENT_LEAVE_FIELD,{m,3},nil,"th","de,dsp",rscon.sumtype("syn"),nil,cm.tg2,cm.op2)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(cm.splimit)
	c:RegisterEffect(e4)
	--summon success
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(cm.sumcon)
	e5:SetOperation(cm.sumsuc)
	c:RegisterEffect(e5)
end
function cm.sumcon(e,tp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and Duel.GetTurnPlayer()~=tp
end
function cm.sumsuc(e,tp)
	local c=e:GetHandler()
	local e1=rsef.SV_IMMUNE_EFFECT(c,rsval.imoe,nil,rsreset.est)
end
function cm.splimit(e,se,sp,st)
	if st&SUMMON_TYPE_SYNCHRO ~=0 then return not se or not se:IsHasType(EFFECT_TYPE_ACTIONS)
	else
		return true
	end
end
function cm.checkfun(mg)
	return mg:IsExists(Card.IsLevel,2,nil,3) and mg:GetClassCount(Card.GetAttribute)==#mg
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function cm.op(e,tp)
	local plist={tp,1-tp}
	local tct=0
	for i=1,2 do 
		local p=plist[i]
		Duel.ConfirmDecktop(p,3)	  
		local g=Duel.GetDecktopGroup(p,3)
		local ct=g:FilterCount(Card.IsType,nil,TYPE_TUNER)
		tct=tct+ct
		Duel.ShuffleDeck(p)
	end
	if tct==0 then return end
	rsof.SelectHint(tp,"td")
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,tct,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
function cm.tdcon(e,tp,eg)
	return eg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function cm.tdop(e,tp)
	rsof.SelectHint(tp,"td")
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TUNER)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,4,PLAYER_ALL,LOCATION_GRAVE)
end
function cm.op2(e,tp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetClassCount(Card.GetCode)<=3 then return end
	rsof.SelectHint(tp,"th")
	local tg=g:SelectSubGroup(tp,aux.dncheck,false,4,4)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
	end
end