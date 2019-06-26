local m=77765050
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=true
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,7)
	local ex=Kaguya.ContinuousCommonEffect(c,EVENT_CUSTOM+77765000)
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--[[e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,3,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_EXTRA)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g)
		if g:GetClassCount(Card.GetCode)>=3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:SelectSubGroup(tp,function(g)
				return g:GetClassCount(Card.GetCode)==#g 
			end,false,3,3)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end)]]
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.counter)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c)
		return c:IsFaceup()
	end)
	e2:SetValue(function(e,c)
		return e:GetHandler():GetCounter(0x1)*-300
	end)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SELF_TOGRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c)
		return c:IsFaceup() and c:IsAttack(0) and c:GetBaseAttack()>0
	end)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(m*16)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ADD_COUNTER|0x1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(Senya.DescriptionCost())
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetCounter(0x1)>=7
	end)
	local function f(c,e,tp)
		return c:IsCode(37564303) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel[c:IsLocation(LOCATION_EXTRA) and "GetLocationCountFromEx" or "GetMZoneCount"](tp)>0 and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
	end
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local ct=c:GetCounter(0x1)
		if chk==0 then return ct>0 and c:IsCanRemoveCounter(tp,0x1,ct,REASON_EFFECT) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,LOCATION_EXTRA+LOCATION_GRAVE)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetCounter(0x1)
		if c:IsRelateToEffect(e) and ct>0 and c:IsCanRemoveCounter(tp,0x1,ct,REASON_EFFECT) then
			c:RemoveCounter(tp,0x1,ct,REASON_EFFECT)
			if Duel.IsExistingMatchingCard(f,1-tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,1-tp) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(1-tp,f,1-tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,1-tp)
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
			end
		end
	end)
	c:RegisterEffect(e3)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=#eg
	if ct>0 then
		e:GetHandler():AddCounter(0x1,ct,true)
	end
end
