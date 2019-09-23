--使徒 宿命者 卡恩
function c14801901.initial_effect(c)
    c:EnableReviveLimit()
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801901,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP,1)
    e1:SetCondition(c14801901.spcons)
    e1:SetOperation(c14801901.spops)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801901,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP,0)
    e2:SetCondition(c14801901.spcon)
    e2:SetOperation(c14801901.spop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c14801901.efilter)
    c:RegisterEffect(e3)
    --cannot attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_ATTACK)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c14801901.antarget)
    c:RegisterEffect(e4)
    --change lp
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801901,2))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c14801901.lpcon)
    e5:SetOperation(c14801901.lpop)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCountLimit(1)
    e6:SetCondition(c14801901.lpcon2)
    e6:SetOperation(c14801901.lpop2)
    c:RegisterEffect(e6)
end
function c14801901.spfilters(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c14801901.spcons(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c14801901.spfilters,tp,0,LOCATION_MZONE,3,nil,tp)
end
function c14801901.spops(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c14801901.spfilters,tp,0,LOCATION_MZONE,3,3,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c14801901.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14801901.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801901.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,3,e:GetHandler())
end
function c14801901.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801901.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,3,3,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801901.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c14801901.antarget(e,c)
    return not c:IsSetCard(0x480d)
end
function c14801901.lpcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and Duel.GetLP(tp)<4000
end
function c14801901.lpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,4000)
end
function c14801901.lpcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.GetLP(1-tp)<4000
end
function c14801901.lpop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(1-tp,4000)
end