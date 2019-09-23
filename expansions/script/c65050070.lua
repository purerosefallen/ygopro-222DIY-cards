--倒映的流忆碎景
function c65050070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65050070+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65050070.tg)
	e1:SetOperation(c65050070.op)
	c:RegisterEffect(e1)
end
function c65050070.filter(c)
   return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c65050070.filter1(c)
   return c:IsSetCard(0xada2) and c:IsAbleToHand()
end
function c65050070.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65050070.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65050070.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c65050070.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SelectTarget(tp,c65050070.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050070.reefil(c,code)
	return not c:IsCode(code)
end
function c65050070.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local og=tc:GetOverlayGroup()
		local xg=og:Filter(Card.IsType,nil,TYPE_XYZ)
		local num=xg:GetCount()
		local g=Duel.GetMatchingGroup(c65050070.filter1,tp,LOCATION_DECK,0,nil)
		local ye=1
		local ng=Group.CreateGroup()
		while g:GetCount()>0 and num>0 and ye==1 do
			local mg=g:FilterSelect(tp,aux.TRUE,1,1,nil)
			ng:Merge(mg)
			local mc=mg:GetFirst()
			local code=mc:GetCode()
			g=g:Filter(c65050070.reefil,nil,code)
			num=num-1
			if g:GetCount()>0 and num>0 then
				if Duel.SelectYesNo(tp,aux.Stringid(65050070,0)) then
					ye=0
				end
			end
		end
		Duel.SendtoHand(ng,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,ng)
	end
end

