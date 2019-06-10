--飞球之魔弹
function c13254097.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13254097,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCountLimit(1,13254097+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c13254097.target)
	e1:SetOperation(c13254097.activate)
	c:RegisterEffect(e1)
	
end
function c13254097.filter(c)
	return c:IsAbleToDeck() and c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1)
end
function c13254097.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c13254097.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13254097.filter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c13254097.filter,tp,LOCATION_GRAVE,0,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c13254097.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local j=Duel.SendtoDeck(tg,tp,2,REASON_EFFECT)
	if j>0 then
		Duel.ShuffleDeck(tp)

		local i=0
		while i<j and (i==0 or Duel.SelectYesNo(tp,aux.Stringid(13254097,1))) do
			Duel.BreakEffect()
			local t1=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
			local t2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(1-tp,1)

			local op=0
			local m={}
			local n={}
			local ct=1
			if t1 then m[ct]=aux.Stringid(13254097,2) n[ct]=1 ct=ct+1 end
			m[ct]=aux.Stringid(13254097,3) n[ct]=2 ct=ct+1
			if t2 then m[ct]=aux.Stringid(13254097,4) n[ct]=3 ct=ct+1 end
			local sp=Duel.SelectOption(tp,table.unpack(m))
			op=n[sp+1]
			if op==0 then return end

			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				if g:GetCount()>0 then
					Duel.Destroy(g,REASON_EFFECT)
				end
			end
			if op==2 then
				Duel.Damage(1-tp,1000,REASON_EFFECT)
			end
			if op==3 then
				local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
				if g:GetCount()>0 then
					Duel.ConfirmCards(p,g)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_HAND,1,1,nil)
					if g:GetCount()>0 then
						Duel.Destroy(g,REASON_EFFECT)
						Duel.Draw(1-tp,1,REASON_EFFECT)
						Duel.ShuffleHand(1-tp)
					end
				end
			end
			i=i+1
		end
	end
end
