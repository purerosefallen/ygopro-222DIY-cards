--渺奏迷景-三重世界
function c65072011.initial_effect(c)
	--change field
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(LOCATION_FZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(c65072011.ccon)
	e0:SetTarget(c65072011.ctg)
	e0:SetOperation(c65072011.cop)
	c:RegisterEffect(e0)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65072011,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65072011.thcost)
	e1:SetTarget(c65072011.thtg)
	e1:SetOperation(c65072011.thop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65072011.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--become effect monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c65072011.eftg)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e4)
end
c65072011.card_code_list={65072000}
function c65072011.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65072011.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c65072011.copfil(c)
	return aux.IsCodeListed(c,65072000) and not c:IsForbidden() and c:IsType(TYPE_FIELD)
end
function c65072011.cop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,c65072011.copfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local code=tc:GetCode()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(11,0,aux.Stringid(code,0))
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetCode(EFFECT_CANNOT_TRIGGER)
		e0:SetRange(LOCATION_FZONE)
		e0:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
	end
end

function c65072011.eftg(e,c)
	return c:IsCode(65071999)
end

function c65072011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_COST) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil,REASON_COST)
end
function c65072011.thfilter(c,tp)
	local code=c:GetCode()
	return aux.IsCodeListed(c,65072000) and c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or c:IsAbleToGrave()) and Duel.IsExistingMatchingCard(c65072011.thfilter2,tp,LOCATION_DECK,0,1,c,c,tp,code)
end
function c65072011.thfilter2(c,mc,tp,code)
	local cd=c:GetCode()
	local g=Group.FromCards(c,mc)
	return aux.IsCodeListed(c,65072000) and c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or c:IsAbleToGrave()) and not c:IsCode(code) and Duel.IsExistingMatchingCard(c65072011.thfilter3,tp,LOCATION_DECK,0,1,g,code,cd)
end
function c65072011.thfilter3(c,code,cd)
	return aux.IsCodeListed(c,65072000) and c:IsType(TYPE_FIELD) and (c:IsAbleToHand() or c:IsAbleToGrave()) and not (c:IsCode(code) or c:IsCode(cd))
end
function c65072011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65072011.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c65072011.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65072011.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local code=g:GetFirst():GetCode()
		local g2=Duel.SelectMatchingCard(tp,c65072011.thfilter2,tp,LOCATION_DECK,0,1,1,g,g:GetFirst(),tp,code)
		local gn=Group.FromCards(g:GetFirst(),g2:GetFirst())
		local cd=g2:GetFirst():GetCode()
		local g3=Duel.SelectMatchingCard(tp,c65072011.thfilter3,tp,LOCATION_DECK,0,1,1,gn,code,cd)
		local sg=Group.FromCards(g:GetFirst(),g2:GetFirst(),g3:GetFirst())
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.ConfirmCards(tp,tg)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(65072011,2)) then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
