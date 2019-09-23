--暗宇宙恶魔 罗什
function c14801966.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c14801966.lcheck)
    c:EnableReviveLimit()
    --atk up
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c14801966.atkval)
    c:RegisterEffect(e1)
    --cannot activate
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c14801966.aclimit)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)
end
function c14801966.lcheck(g,lc)
    return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function c14801966.atkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c14801966.atkval(e,c)
    local g=Duel.GetMatchingGroup(c14801966.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
    return g:GetSum(Card.GetLink)*300
end
function c14801966.aclimit(e,re,tp)
    local tc=re:GetHandler()
    return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsSummonType(SUMMON_TYPE_SPECIAL) and not tc:IsLinkState() and re:IsActiveType(TYPE_MONSTER) and not tc:IsImmuneToEffect(e)
end