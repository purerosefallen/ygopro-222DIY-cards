--穹顶煌刃 雪暴
local m=14000358
local cm=_G["c"..m]
cm.named_with_Skayarder=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--[[Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.scon)
	e2:SetTarget(cm.stg)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)]]
end
function cm.Skay(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Skayarder
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,2000,1200,4,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,2000,1200,4,RACE_MACHINE,ATTRIBUTE_WIND) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e_1=Effect.CreateEffect(c)
		e_1:SetType(EFFECT_TYPE_SINGLE)
		e_1:SetCode(EFFECT_CHANGE_TYPE)
		e_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e_1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e_1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e_1,true)
		local e2=e_1:Clone()
		e2:SetCode(EFFECT_ADD_RACE)
		e2:SetValue(RACE_MACHINE)
		c:RegisterEffect(e2,true)
		local e3=e_1:Clone()
		e3:SetCode(EFFECT_ADD_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_WIND)
		c:RegisterEffect(e3,true)
		local e4=e_1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(2000)
		c:RegisterEffect(e4,true)
		local e5=e_1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(1200)
		c:RegisterEffect(e5,true)
		local e6=e_1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(8)
		Duel.SpecialSummonComplete()
	end
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not cm.Skay(c)
end
function cm.cfilter(c,tp)
	return cm.Skay(c) and c:GetSummonPlayer()==tp
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 or c:GetFlagEffect(m)~=0) and eg:IsExists(cm.cfilter,1,c,tp)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local cg=eg:Filter(cm.cfilter,c,tp)
	local ct=cg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end