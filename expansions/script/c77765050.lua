local m=77765050
local cm=_G["c"..m]
Duel.LoadScript("c77765000.lua")
cm.Senya_name_with_difficulty=true
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,6)
	local ex=Kaguya.ContinuousCommonEffect(c,EVENT_FREE_CHAIN,function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)==16
	end,Senya.DescriptionCost())
	ex:SetProperty(0)
	ex:SetType(EFFECT_TYPE_QUICK_O)
	ex:SetDescription(m*16+1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
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
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(cm.counter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(m*16)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(Senya.DescriptionCost())
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetCounter(0x1)>=6
	end)
	local function f(c,e,tp)
		return c:IsCode(37564303) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel[c:IsLocation(LOCATION_EXTRA) and "GetLocationCountFromEx" or "GetMZoneCount"](tp)>0 and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
	end
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(f,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if Duel.IsExistingMatchingCard(f,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
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
