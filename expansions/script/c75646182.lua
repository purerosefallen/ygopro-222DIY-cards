--崩坏神格 盘龙
function c75646182.initial_effect(c)
	c:SetUniqueOnField(1,0,75646182)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c75646182.target)
	e1:SetOperation(c75646182.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c75646182.eqlimit)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetCondition(c75646182.effcon1)
	e3:SetValue(c75646182.atlimit)
	c:RegisterEffect(e3)
	--Atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c75646182.effcon2)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2c0))
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c75646182.atkcon)
	e5:SetOperation(c75646182.atkop)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(3,75646150)
	e6:SetCost(c75646182.thcost)
	e6:SetTarget(c75646182.thtg)
	e6:SetOperation(c75646182.thop)
	c:RegisterEffect(e6)
end
c75646182.card_code_list={75646000,75646155}
function c75646182.eqlimit(e,c)
	return c:IsSetCard(0x2c0)
end
function c75646182.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c0)
end
function c75646182.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c75646182.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646182.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c75646182.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c75646182.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c75646182.effilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c0)
end
function c75646182.efilter(c)
	return c:IsFaceup() and c:IsCode(75646183)
end
function c75646182.effcon1(e)
	if Duel.IsExistingMatchingCard(c75646182.efilter,tp,LOCATION_SZONE,0,1,nil) then e:SetLabel(0) else e:SetLabel(3) end
	return Duel.GetMatchingGroup(c75646182.effilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c75646182.effcon2(e)
	if Duel.IsExistingMatchingCard(c75646182.efilter,tp,LOCATION_SZONE,0,1,nil) then e:SetLabel(2) else e:SetLabel(5) end
	return Duel.GetMatchingGroup(c75646182.effilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c75646182.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c75646182.efilter,tp,LOCATION_SZONE,0,1,nil) then e:SetLabel(4) else e:SetLabel(7) end
	local a=Duel.GetAttacker()
	if not a:IsControler(tp) then
		a=Duel.GetAttackTarget()
	end
	return a and a:IsSetCard(0x2c0) and Duel.GetMatchingGroup(c75646182.effilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c75646182.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75646182)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	local res=Duel.TossCoin(tp,1)
	if res==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
	end  
end 
function c75646182.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x2c0)
end
function c75646182.cfilter(c)
	return aux.IsCodeListed(c,75646000) and c:IsAbleToRemoveAsCost()
end
function c75646182.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c75646182.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646182.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75646182.thfilter(c)
	return c:IsSetCard(0x2c0) and c:IsAbleToHand()
end
function c75646182.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646182.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646182.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75646182.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end