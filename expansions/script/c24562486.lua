--猛毒性 折獴斩蝰
function c24562486.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24562486,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,24562486)
	e1:SetTarget(c24562486.thtg)
	e1:SetOperation(c24562486.thop)
	c:RegisterEffect(e1)
end
function c24562486.thfilter(c,e,tp)
	return c:IsSetCard(0x9390) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24562486.thfil2(c,g)
	return g:IsExists(c24562486.thfil3,1,c,c:GetCode())
end
function c24562486.thfil3(c,code)
	return not c:IsCode(code)
end
function c24562486.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c24562486.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetAttack)>=2 then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c24562486.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c24562486.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local dg=g:Filter(c24562486.thfil2,nil,g)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if b2>0 and dg:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:Remove(Card.IsCode,nil,tc1:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc2=dg:Select(tp,1,1,nil):GetFirst()
		local g9=Group.FromCards(tc1,tc2)
		Duel.ConfirmCards(1-tp,g9)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local cg=g9:RandomSelect(1-tp,1)
		local tc3=cg:GetFirst()
		local g2=Group.CreateGroup()
		g2:AddCard(tc3)
		local tc4=g2:GetFirst()
		if g9:RemoveCard(tc3)~=0 then tc5=g9:GetFirst() end
		Duel.Hint(HINT_CARD,0,tc4:GetCode())
		if tc4:IsAbleToRemove() 
		  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		  and tc5:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.Remove(tc4,POS_FACEUP,REASON_EFFECT)
		end
			Duel.SpecialSummon(tc5,0,tp,tp,false,false,POS_FACEUP)
	end
end