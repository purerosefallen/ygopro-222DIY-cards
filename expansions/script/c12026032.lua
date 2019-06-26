--三位一体的女神 拉结尔
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c12026032.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,12026032)
	e1:SetCondition(c12026032.spcon)
	e1:SetOperation(c12026032.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12026032,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,12026032+100)
	e2:SetCost(c12026032.thcost)
	e2:SetTarget(c12026032.thtg)
	e2:SetOperation(c12026032.thop)
	c:RegisterEffect(e2)
	--leave field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c12026032.regop)
	c:RegisterEffect(e2)
end
function c12026032.confilter(c,ec)
	return c:IsCanBeSynchroMaterial(ec) and c:IsSetCard(0x1fbd) and c:IsFaceup() and c:IsAbleToGraveAsCost() and c:GetLevel()>0 and c:IsSummonableCard()
end
function c12026032.gcheck(g,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 and g:GetSum(Card.GetLevel)==3
end
function c12026032.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c12026032.confilter,tp,LOCATION_MZONE,0,nil,c)
	return Senya.CheckGroup(mg,c12026032.gcheck,nil,1,4,tp,c)
end
function c12026032.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c12026032.confilter,tp,LOCATION_MZONE,0,nil,c)
	local g=Senya.SelectGroup(tp,HINTMSG_TOGRAVE,mg,c12026032.gcheck,nil,1,3,tp,c)
	Duel.SendtoGrave(g,REASON_COST)
end

function c12026032.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeck()
end
function c12026032.thcost(c)
	if chk==0 then return Duel.IsExistingMatchingCard(c12026032.thfilter1,tp,LOCATION_GRAVE,0,3,nil) end
	local tc=Duel.SelectMatchingCard(tp,c12026032.thfilter1,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
end
function c12026032.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c12026032.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12026032.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12026032.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12026032.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount() then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(g,1-tp)
	end
end
function c12026032.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_HAND_LIMIT)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(99)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
end
