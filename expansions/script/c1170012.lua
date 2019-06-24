--拟生狐召唤术
function c1170012.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1170012.con1)
	e1:SetCost(c1170012.cost1)
	e1:SetTarget(c1170012.tg1)
	e1:SetOperation(c1170012.op1)
	c:RegisterEffect(e1)
--
end
--
function c1170012.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1 or e:GetCost()
end
function c1170012.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local rg=Duel.GetReleaseGroup(tp)
	if chk==0 then
		if e:GetCondition() and cg:GetCount()<1 then return true
		else return (cg:GetCount()>0 or rg:GetCount()>0) and cg:FilterCount(Card.IsReleasable,nil)==cg:GetCount() end
	end
	if cg:GetCount()>0 then Duel.Release(rg,REASON_COST) end
end
--
function c1170012.tfilter1(c,e,tp)
	local b1=c:IsAbleToHand()
	local b2=Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_BEAST) and (b1 or b2)
end
function c1170012.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.IsExistingMatchingCard(c1170012.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
--
function c1170012.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<0 then return end
	local sg=Duel.GetMatchingGroup(c1170012.tfilter1,tp,LOCATION_DECK,0,nil,e,tp)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=sg:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=sg:GetNext()
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	local b1=spcard:IsAbleToHand()
	local b2=Duel.GetMZoneCount(tp)>0 and spcard:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if not (b1 or b2) then Duel.ShuffleDeck(tp) end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1170012,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1170012,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		Duel.SendtoHand(spcard,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,spcard)
	else
		Duel.SpecialSummon(spcard,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.ShuffleDeck(tp)
end
--
