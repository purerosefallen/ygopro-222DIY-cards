--蜜食彩虹 虹彩幻想
function c65050176.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050176,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,65050176)
	e1:SetCondition(c65050176.con)
	e1:SetTarget(c65050176.tg)
	e1:SetOperation(c65050176.op)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050176,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65050176.atkcon)
	e2:SetOperation(c65050176.atkop)
	c:RegisterEffect(e2)
end
function c65050176.confil(c)
	return c:IsReleasableByEffect() and c:IsFaceup() and c:IsAttack(0) and c:IsLocation(LOCATION_MZONE)
end
function c65050176.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050176.confil,1,nil)
end
function c65050176.thfil(c)
	return c:IsSetCard(0x6da8) and c:IsAbleToHand()
end
function c65050176.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050176.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050176.op(e,tp,eg,ep,ev,re,r,rp)
	local rg=eg:Filter(c65050176.confil,nil)
	if rg:GetCount()>0 then
		local rc=Duel.Release(rg,REASON_EFFECT) 
		if rc~=0 and Duel.IsExistingMatchingCard(c65050176.thfil,tp,LOCATION_DECK,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c65050176.thfil,tp,LOCATION_DECK,0,1,rc,nil)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function c65050176.atkfil(c)
	return c:IsFaceup() and not c:IsAttack(2000)
end
function c65050176.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050176.atkfil,1,nil)
end
function c65050176.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65050176.atkfil,nil):Filter(Card.IsFaceup,nil)
	local gc=g:GetFirst()
	while gc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		gc:RegisterEffect(e1)
		gc=g:GetNext()
	end
end
