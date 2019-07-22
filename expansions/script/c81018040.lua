--冰蓝之心·最上静香
require("expansions/script/c81000000")
function c81018040.initial_effect(c)
	c:EnableReviveLimit()
	Tenka.Shizuka(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x81b),1,1)
	--addown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81018040,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81018040)
	e1:SetOperation(c81018040.operation)
	c:RegisterEffect(e1)
	--addown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81018040,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81018940)
	e3:SetCondition(c81018040.condition)
	e3:SetOperation(c81018040.operation)
	c:RegisterEffect(e3)
end
function c81018040.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x81b) and not c:IsCode(81018040)
end
function c81018040.condition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c81018040.cfilter,1,nil,tp)
end
function c81018040.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
