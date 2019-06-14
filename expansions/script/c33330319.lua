--THE DRAWER 玄墨
local m=33330319
local cm=_G["c"..m]
cm.name="THE DRAWER"
function c33330319.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,c33330319.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
  --special summon
----	local e2=Effect.CreateEffect(c)
 --   e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
 --   e2:SetType(EFFECT_TYPE_IGNITION)
 --   e2:SetRange(LOCATION_GRAVE)
  --  e2:SetCountLimit(1,33330319)
  --  e2:SetCost(c33330319.spcost)
  --  e2:SetTarget(c33330319.sptg)
  --  e2:SetOperation(c33330319.spop)
  --  c:RegisterEffect(e2)
--end
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17031211,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,33330319)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33330319,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c33330319.tgtg)
	e2:SetOperation(c33330319.tgop)
	c:RegisterEffect(e2)
	--nontuner
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e4)

end

function c33330319.tfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end


function cm.spcfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5) 
end
function cm.costfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then
			return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_MZONE,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if ft==0 then
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Release(g,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Release(g,REASON_COST)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   -- if not c:IsRelateToEffect(e) then return end
   -- Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
 if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
---to deck
function c33330319.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR) and c:IsAbleToGrave()
end
function c33330319.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330319.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c33330319.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c33330319.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
