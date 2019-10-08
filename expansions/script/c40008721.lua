--镜争兽·生化绿避役
function c40008721.initial_effect(c)
	--cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetCountLimit(1)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c40008721.mtcon)
	e0:SetOperation(c40008721.mtop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008721,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,40008721)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c40008721.target)
	e1:SetOperation(c40008721.operation)
	c:RegisterEffect(e1)	
end
function c40008721.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c40008721.cfilter1(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c40008721.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c40008721.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local dg=g1:GetMinGroup(Card.GetAttack)
	local select=1
	if dg:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(40008721,0),aux.Stringid(40008721,1))
	else
		select=Duel.SelectOption(tp,aux.Stringid(40008721,1))+1
	end
	if select==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=dg:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	else
		Duel.Destroy(c,REASON_COST)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-1000)
	end
end
function c40008721.filter(c,e,tp)
	return c:IsSetCard(0xf15) and not c:IsCode(40008721) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c40008721.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40008721.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40008721.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40008721.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end