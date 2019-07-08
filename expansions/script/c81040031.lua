--梦落初春·周子
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c81040031.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81040031.matfilter,1,1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MINIATURE_GARDEN_GIRL)
	e1:SetValue(1)
	e1:SetTarget(function(e,c)
		return c:IsSetCard(0x81c)
	end)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,81040031)
	e2:SetCondition(c81040031.tgcon)
	e2:SetTarget(c81040031.tgtg)
	e2:SetOperation(c81040031.tgop)
	c:RegisterEffect(e2)
end
function c81040031.matfilter(c)
	return c:IsLinkSetCard(0x81c) and c:IsLinkType(TYPE_RITUAL)
end
function c81040031.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81040031.tgfilter(c)
	return c:IsSetCard(0x81c) and c:IsAbleToGrave()
end
function c81040031.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040031.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81040031.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81040031.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
