--沁恋甜心的小邀约
function c65050096.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,65050096)
	e2:SetCondition(c65050096.ntcon)
	e2:SetTarget(c65050096.nttg)
	e2:SetOperation(c65050096.ntop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c65050096.chaincon)
	e3:SetOperation(c65050096.chainop)
	c:RegisterEffect(e3)
end
function c65050096.ntcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLevelAbove,1,nil,6)
end
function c65050096.nt1f(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0xcda2) and c:IsAbleToHand()
end
function c65050096.nt2f(c,e,tp)
	return c:IsSetCard(0xcda2) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65050096.nttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bg=eg:Filter(Card.IsLevelAbove,nil,6)
	local b1=bg:IsExists(Card.IsType,1,nil,TYPE_FUSION) and Duel.IsExistingMatchingCard(c65050096.nt1f,tp,LOCATION_GRAVE,0,1,nil)
	local b2=bg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c65050096.nt2f,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
	if chk==0 then return b1 or b2 end
	local m=8
	if b1 and b2 then 
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		m=0
	elseif b1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
		m=1
	elseif b2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
		m=2
	end
	e:SetLabel(m)
end
function c65050096.ntop(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	if m==0 or m==1 then
		local g1=Duel.SelectMatchingCard(tp,c65050096.nt1f,tp,LOCATION_GRAVE,0,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoHand(g1,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
	if (m==0 or m==2) and Duel.GetMZoneCount(tp)>0 then
		local g2=Duel.SelectMatchingCard(tp,c65050096.nt2f,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g2:GetCount()>0 then
			Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c65050096.ccfil(c)
	return c:IsFaceup() and c:IsLevelAbove(6)
end
function c65050096.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65050096.ccfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c65050096.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xcda2) and re:GetHandler():IsType(TYPE_TUNER) and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(c65050096.chainlm)
	end
end
function c65050096.chainlm(e,rp,tp)
	return tp==rp
end
