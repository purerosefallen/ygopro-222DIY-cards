--沁恋甜心 矜持之月季
function c65050083.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xcda2),c65050083.ffilter,true)
	--spsummon  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,65050084)
	e1:SetCondition(c65050083.con)
	e1:SetTarget(c65050083.tg)
	e1:SetOperation(c65050083.op)
	c:RegisterEffect(e1)
	 --tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65050083)
	e2:SetTarget(c65050083.tgtg)
	e2:SetOperation(c65050083.tgop)
	c:RegisterEffect(e2)
end
function c65050083.ffilter(c)
	return c:IsFusionSetCard(0xcda2) and c:IsLevelAbove(6)
end

function c65050083.spfil(c,e,tp)
	return c:IsSetCard(0xcda2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_GRAVE)
end
function c65050083.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050083.spfil,1,nil,e,tp)
end
function c65050083.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050083.op(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:FilterSelect(tp,c65050083.spfil,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65050083.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c65050083.tgfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65050083.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c65050083.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,LOCATION_ONFIELD)
end
function c65050083.tgfil(c,tp)
	local typ=0
	if c:IsType(TYPE_MONSTER) then typ=TYPE_MONSTER end
	if c:IsType(TYPE_SPELL) then typ=TYPE_SPELL end
	if c:IsType(TYPE_TRAP) then typ=TYPE_TRAP end
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c65050083.thfil,tp,LOCATION_DECK,0,1,nil,typ)
end
function c65050083.thfil(c,typ)
	return c:IsType(typ) and c:IsAbleToHand() and c:IsSetCard(0xcda2)
end
function c65050083.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local typ=0
		if tc:IsType(TYPE_MONSTER) then typ=TYPE_MONSTER end
		if tc:IsType(TYPE_SPELL) then typ=TYPE_SPELL end
		if tc:IsType(TYPE_TRAP) then typ=TYPE_TRAP end
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65050083.thfil,tp,LOCATION_DECK,0,1,nil,typ) then
			local g=Duel.SelectMatchingCard(tp,c65050083.thfil,tp,LOCATION_DECK,0,1,1,nil,typ)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end