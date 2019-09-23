--使徒 征服者 卡西利亚斯
function c14801904.initial_effect(c)
    c:EnableReviveLimit()
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801904,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP,1)
    e1:SetCondition(c14801904.spcons)
    e1:SetOperation(c14801904.spops)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801904,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP,0)
    e2:SetCondition(c14801904.spcon)
    e2:SetOperation(c14801904.spop)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --cannot attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_ATTACK)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c14801904.antarget)
    c:RegisterEffect(e4)
    --atkup
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801904,2))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetOperation(c14801904.atkop)
    c:RegisterEffect(e5)
end
function c14801904.spfilters(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c14801904.spcons(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c14801904.spfilters,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c14801904.spops(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c14801904.spfilters,tp,0,LOCATION_MZONE,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c14801904.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14801904.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801904.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler())
end
function c14801904.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801904.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801904.antarget(e,c)
    return not c:IsSetCard(0x480d)
end
function c14801904.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    e1:SetValue(500)
    c:RegisterEffect(e1)
end