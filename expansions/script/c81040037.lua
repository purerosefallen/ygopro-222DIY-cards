--冬日回忆·周子
local m=81040037
local c81040037=_G["c"..m]
Duel.LoadScript("c37564765.lua")
function c81040037.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c81040037.ffilter,3,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--特招方法
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetValue(1)
	e5:SetCondition(c81040037.spscon)
	e5:SetOperation(c81040037.spsop)
	c:RegisterEffect(e5)
	--immune effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c81040037.immunefilter)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c81040037.indes)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,81040037)
	e3:SetCost(c81040037.tdcost)
	e3:SetTarget(c81040037.tdtg)
	e3:SetOperation(c81040037.tdop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,81040937)
	e4:SetCondition(c81040037.spcon)
	e4:SetTarget(c81040037.sptg)
	e4:SetOperation(c81040037.spop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(81040037,ACTIVITY_SPSUMMON,c81040037.counterfilter)
end
function c81040037.counterfilter(c)
	return c:IsSetCard(0x81c)
end
function c81040037.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81c) and bit.band(c:GetType(),0x81)==0x81
end
function c81040037.spsfilter(c)
	return c:IsSetCard(0x81c) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToRemoveAsCost() 
end
function c81040037.spscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81040037.spsfilter,tp,LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCountFromEx(tp)>0
		and g:GetClassCount(Card.GetCode)>=3
		and Duel.IsExistingMatchingCard(c81040037.exfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81040037.spsop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81040037.spsfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Group.CreateGroup()
	for i=1,3 do	 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		tg:Merge(sg)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	end
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
end
function c81040037.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x81c) and c:IsFusionType(TYPE_RITUAL) and c:IsFusionType(TYPE_MONSTER) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c81040037.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner() and not te:GetHandler():IsType(TYPE_RITUAL)
end
function c81040037.indes(e,c)
	return not (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER))
end
function c81040037.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetCustomActivityCount(81040037,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c81040037.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c81040037.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x81c)
end
function c81040037.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81c) and c:IsAbleToDeck()
end
function c81040037.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c81040037.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c81040037.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler())
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81040037.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c81040037.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c81040037.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81040037.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81040037,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c81040037.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c81040037.filter(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsSetCard(0x81c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c81040037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81040037.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81040037.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81040037.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP) then
		tc:CompleteProcedure()
	end
end
