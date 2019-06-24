--咖啡时间·爱米莉
function c81012050.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--destroy & search
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,81012050)
	e0:SetCondition(c81012050.thcon)
	e0:SetTarget(c81012050.thtg)
	e0:SetOperation(c81012050.thop)
	c:RegisterEffect(e0)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81012950)
	e1:SetCost(c81012050.spcost)
	e1:SetTarget(c81012050.sptg)
	e1:SetOperation(c81012050.spop)
	c:RegisterEffect(e1)
	--pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c81012050.pencon)
	e5:SetTarget(c81012050.pentg)
	e5:SetOperation(c81012050.penop)
	c:RegisterEffect(e5)
end
c81012050.pendulum_level=4
function c81012050.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c81012050.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsLevelBelow(8)
		and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c81012050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.IsExistingMatchingCard(c81012050.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81012050.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c81012050.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c81012050.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81012050.cfilter(c,e,tp,m,ft)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsType(TYPE_PENDULUM) or c:IsPublic()
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil,tp)
	end
	local sg=Group.CreateGroup()
	return m:IsExists(c81012050.spselect,1,nil,c,0,ft,m,sg)
end
function c81012050.spgoal(mc,ct,sg)
	return sg:CheckWithSumEqual(Card.GetRitualLevel,mc:GetLevel(),ct,ct,mc) and sg:GetClassCount(Card.GetCode)==ct
end
function c81012050.spselect(c,mc,ct,ft,m,sg)
	sg:AddCard(c)
	ct=ct+1
	local res=(ft>=ct and c81012050.spgoal(mc,ct,sg)) or m:IsExists(c81012050.spselect,1,sg,mc,ct,ft,m,sg)
	sg:RemoveCard(c)
	return res
end
function c81012050.filter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_PYRO) and Duel.IsPlayerCanRelease(tp,c)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c81012050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local mg=Duel.GetMatchingGroup(c81012050.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
		return Duel.IsExistingMatchingCard(c81012050.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c81012050.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(c81012050.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c81012050.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	if tg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,tg)
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		local sg=Group.CreateGroup()
		for i=0,98 do
			local cg=mg:Filter(c81012050.spselect,sg,tc,i,ft,mg,sg)
			if cg:GetCount()==0 then break end
			local min=1
			if c81012050.spgoal(tc,i,sg) then
				if not Duel.SelectYesNo(tp,210) then break end
				min=0
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=cg:Select(tp,min,1,nil)
			if g:GetCount()==0 then break end
			sg:Merge(g)
		end
		if sg:GetCount()==0 then return end
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)==sg:GetCount() then
			local og=Duel.GetOperatedGroup()
			Duel.ConfirmCards(1-tp,og)
			tc:SetMaterial(og)
			Duel.Release(og,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c81012050.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c81012050.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c81012050.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
