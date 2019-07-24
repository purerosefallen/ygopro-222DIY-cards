--小绿加速器2
function c12033011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12033011.target)
	e1:SetOperation(c12033011.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12033011,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1,12033011)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c12033011.thcon)
	e2:SetTarget(c12033011.thtg)
	e2:SetOperation(c12033011.thop)
	c:RegisterEffect(e2)
end
function c12033011.filter1(c)
	return c:IsSetCard(0xfa2) and c:IsType(TYPE_MONSTER)  and c:IsAbleToHand() 
end
function c12033011.filter2(c)
	return c:IsSetCard(0xfa2) and  c:IsType(TYPE_SPELL+TYPE_TRAP)  and  c:IsAbleToHand() and not c:IsCode(12033011)
end
function c12033011.rfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xfa2)
end
function c12033011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12033011.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	local g=Duel.GetMatchingGroup(c12033011.rfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>=3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	end
end
function c12033011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12033011.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g=Duel.GetMatchingGroup(c12033011.rfilter,tp,LOCATION_GRAVE,0,nil)
		local ct=g:GetClassCount(Card.GetCode)
		if Duel.IsPlayerCanDraw(tp,1) and ct>2 and Duel.IsExistingMatchingCard(c12033011.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12033011,0)) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			   local tg=Duel.SelectMatchingCard(tp,c12033011.filter2,tp,LOCATION_DECK,0,1,1,nil)
			   if tg:GetCount()>0 then
				  Duel.SendtoHand(tg,nil,REASON_EFFECT)
				  Duel.ConfirmCards(1-tp,tg)
			   end
		end
	end
end
function c12033011.rccfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xfa2)
end
function c12033011.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
		and Duel.IsExistingMatchingCard(c12033011.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12033011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c12033011.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
