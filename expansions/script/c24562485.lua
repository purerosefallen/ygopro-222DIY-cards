--猛毒性 桠接芽园
function c24562485.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,24562485)
	e1:SetCost(c24562485.e1cost)
	e1:SetTarget(c24562485.e1tg)
	e1:SetOperation(c24562485.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,24562444)
	e2:SetCost(c24562485.atkcost)
	e2:SetTarget(c24562485.target)
	e2:SetOperation(c24562485.activate)
	c:RegisterEffect(e2)
end
function c24562485.cfilter(c)
	return c:IsSetCard(0x9390) and c:IsAbleToRemoveAsCost()
end
function c24562485.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562485.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24562485.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24562485.thfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9390) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c24562485.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c24562485.thfilter,tp,LOCATION_REMOVED,0,nil,e)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c24562485.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
--
function c24562485.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24562485.e1cfil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost()end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c24562485.e1cfil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c24562485.e1cfil(c)
	return c:IsSetCard(0x9390) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and (c:GetLevel()>=3 or c:GetRank()>=3)
end
function c24562485.e1op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if not Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsPlayerCanDraw(1-tp,3) and Duel.IsPlayerCanDraw(1-tp,2) then return false end
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==3 or dc==5 then
		ac=1
	elseif dc==2 or dc==4 then
		ac=2
	elseif dc==6 then
		ac=3
	end
	local dr=Duel.Draw(p,ac,REASON_EFFECT)
	if p~=tp and dr~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,dr*1000,REASON_EFFECT)
	end
end
function c24562485.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,3) and Duel.IsPlayerCanDraw(1-tp,2) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end