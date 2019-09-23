--沁恋甜心 温馨之向日葵
function c65050085.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xcda2),1)
	c:EnableReviveLimit()
	--hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050085,2))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65050085)
	e1:SetCost(c65050085.cost)
	e1:SetTarget(c65050085.tg)
	e1:SetOperation(c65050085.op)
	c:RegisterEffect(e1)
	--hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65050085,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65050086)
	e2:SetCost(c65050085.cost2)
	e2:SetTarget(c65050085.tg2)
	e2:SetOperation(c65050085.op2)
	c:RegisterEffect(e2)
end
function c65050085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_COST) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,nil,REASON_COST+REASON_DISCARD)
end
function c65050085.seefil(c)
	return not c:IsPublic()
end
function c65050085.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050085.seefil,tp,0,LOCATION_HAND,1,nil) end
end
function c65050085.thfil(c,typ)
	return c:IsType(typ) and c:IsAbleToHand() and c:IsSetCard(0xcda2)
end
function c65050085.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(1-tp,c65050085.seefil,tp,0,LOCATION_HAND,1,1,nil)
	if sg:GetCount()>0 then
		Duel.ConfirmCards(tp,sg)
		local tc=sg:GetFirst()
		local typ=0
		if tc:IsType(TYPE_MONSTER) then typ=TYPE_MONSTER end
		if tc:IsType(TYPE_SPELL) then typ=TYPE_SPELL end
		if tc:IsType(TYPE_TRAP) then typ=TYPE_TRAP end
		local b=Duel.IsExistingMatchingCard(c65050085.thfil,tp,LOCATION_DECK,0,1,nil,typ)
		local op=2
		if b then
			op=Duel.SelectOption(tp,aux.Stringid(65050085,0),aux.Stringid(65050085,1))
		else
			op=1
		end
		if op==0 then
			local g=Duel.SelectMatchingCard(tp,c65050085.thfil,tp,LOCATION_DECK,0,1,1,nil,typ)
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(1-tp)
		elseif op==1 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end

function c65050085.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65050085.spfil(c,e,tp)
	return c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsSetCard(0xcda2)
end
function c65050085.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65050085.spfil(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050085.spfil,tp,LOCATION_GRAVE,0,2,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	local g=Duel.SelectTarget(tp,c65050085.spfil,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c65050085.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end