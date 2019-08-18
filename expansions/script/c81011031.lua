--环游×旅行
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
c81011031.Senya_desc_with_nanahira=true
function c81011031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,81011031)
	e1:SetCondition(c81011031.condition)
	e1:SetTarget(c81011031.target)
	e1:SetOperation(c81011031.operation)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,81011931)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c81011031.thtg)
	e3:SetOperation(c81011031.thop)
	c:RegisterEffect(e3)
end
function c81011031.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousCodeOnField()==37564765 and c:GetPreviousControler()==tp
end
function c81011031.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81011031.cfilter,1,nil,tp)
end
function c81011031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2850)
end
function c81011031.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,2850,REASON_EFFECT,true)
	Duel.Recover(tp,2100,REASON_EFFECT,true)
	Duel.RDComplete()
end
function c81011031.thfilter(c)
	return c.Senya_desc_with_nanahira and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c81011031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81011031.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81011031.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81011031.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
