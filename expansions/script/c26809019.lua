--Lasciviousness
function c26809019.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,26809019)
	e2:SetTarget(c26809019.tdtg)
	e2:SetOperation(c26809019.tdop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=aux.AddRitualProcGreater2(c,nil,nil,nil,c26809019.mfilter)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(0)
	e3:SetCountLimit(1,26809919)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c26809019.cost)
end
function c26809019.mfilter(c,e,tp)
	return c~=e:GetHandler()
end
function c26809019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c26809019.tdfilter(c)
	return c:IsType(TYPE_RITUAL)
end
function c26809019.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26809019.tdfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c26809019.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26809019,3))
	local g=Duel.SelectMatchingCard(tp,c26809019.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
