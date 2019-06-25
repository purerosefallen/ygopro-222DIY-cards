local m=77765020
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=true
function cm.initial_effect(c)
	local ex=Kaguya.ContinuousCommonEffect(c,0,aux.TRUE)
	ex:SetType(EFFECT_TYPE_IGNITION)
	ex:SetProperty(0)
	ex:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end)
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetTarget(cm.target)
	--e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(function(e,c,tp)
		--local tp=e:GetHandlerPlayer()
		return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)>=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	end)
	c:RegisterEffect(e4)
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetLabelObject(e4)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local te=e:GetLabelObject()
		te:SetValue(Duel.GetFieldGroupCount(tp,0,LOCATION_HAND))
	end)
	c:RegisterEffect(e1)]]
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(function(e,c)
		return c:IsCode(77765001) and c:IsFaceup()
	end)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(function(e,tp,eg)
		return eg:GetFirst():IsCode(77765001) and Duel.GetAttackTarget()==nil
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=eg:GetFirst()
		local ee=Effect.CreateEffect(e:GetHandler())
		ee:SetType(EFFECT_TYPE_SINGLE)
		ee:SetCode(EFFECT_UPDATE_ATTACK)
		ee:SetValue(300)
		ee:SetReset(0x1fe1000)
		tc:RegisterEffect(ee)
	end)
	c:RegisterEffect(e1)
	--Description Required:
		--0: Send to GY
		--1: Special Summon Kaguya
	--[[local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(Senya.DescriptionCost())
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(Senya.DescriptionCost())
	e1:SetTarget(cm.target2)
	e1:SetOperation(cm.operation2)
	c:RegisterEffect(e1)
	if not cm.check then
		cm.check=0
		local ex1=Effect.GlobalEffect()
		ex1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ex1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return eg:IsExists(function(c)
				return c:IsCode(77765001) and c:GetSummonLocation()==LOCATION_GRAVE
			end,1,nil)
		end)
		ex1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			cm.check=cm.check+1
			if cm.check%3==0 then
				Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
			end
		end)
		Duel.RegisterEffect(ex1,0)
		local ex1=Effect.GlobalEffect()
		ex1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ex1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			cm.check=0
		end)
		Duel.RegisterEffect(ex1,0)
	end]]
end
--[[function cm.tgfilter(c)
	return c:IsCode(77765001) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function cm.filter(c,e,tp)
	return c:IsCode(77765001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
]]
