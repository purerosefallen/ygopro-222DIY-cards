--伽古拉斯·伽古拉
function c14801210.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x4803),1,1)
    c:EnableReviveLimit()
    --cannot target
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetValue(aux.tgoval)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --avoid battle damage
    local e4=e2:Clone()
    e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    c:RegisterEffect(e4)
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801210,0))
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,14801210)
    e3:SetTarget(c14801210.target)
    e3:SetOperation(c14801210.activate)
    c:RegisterEffect(e3)
end
function c14801210.tdfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4803) and c:IsAbleToDeck()
end
function c14801210.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c14801210.tdfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c14801210.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c14801210.tdfilter,tp,LOCATION_GRAVE,0,nil)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end