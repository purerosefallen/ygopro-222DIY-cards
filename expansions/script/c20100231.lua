--御刀使-折神紫
local m=20100231
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100000") end,function() require("script/c20100000") end)
function cm.initial_effect(c)
	--link summon
	C9.TojiMonster(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),2,99,cm.lcheck)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	
end

function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc90)
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc90) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end

function cm.sfillter(c,e,tp)
	return c:IsSetCard(0xc90) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.sfillter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.sfillter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
