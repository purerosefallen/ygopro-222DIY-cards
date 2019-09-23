--使徒 天骄·依西斯 普雷
function c14801903.initial_effect(c)
   c:EnableReviveLimit()
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801903,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP,1)
    e1:SetCondition(c14801903.spcons)
    e1:SetOperation(c14801903.spops)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801903,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP,0)
    e2:SetCondition(c14801903.spcon)
    e2:SetOperation(c14801903.spop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c14801903.efilter)
    c:RegisterEffect(e3)
    --cannot attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_ATTACK)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c14801903.antarget)
    c:RegisterEffect(e4)
    --destroy all
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801903,2))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c14801903.decon)
    e5:SetTarget(c14801903.destg)
    e5:SetOperation(c14801903.desop)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCountLimit(1)
    e6:SetCondition(c14801903.decon2)
    e6:SetTarget(c14801903.destg2)
    e6:SetOperation(c14801903.desop2)
    c:RegisterEffect(e6)
end
function c14801903.spfilters(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c14801903.spcons(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c14801903.spfilters,tp,0,LOCATION_MZONE,2,nil,tp)
end
function c14801903.spops(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c14801903.spfilters,tp,0,LOCATION_MZONE,2,2,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c14801903.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14801903.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801903.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,e:GetHandler())
end
function c14801903.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801903.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801903.efilter(e,re)
    return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function c14801903.antarget(e,c)
    return not c:IsSetCard(0x480d)
end
function c14801903.decon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c14801903.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c14801903.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c14801903.filter,tp,0,LOCATION_ONFIELD,1,c,nil) end
    local sg=Duel.GetMatchingGroup(c14801903.filter,tp,0,LOCATION_ONFIELD,c,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c14801903.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c14801903.filter,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
function c14801903.decon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c14801903.filter2(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c14801903.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c14801903.filter2,tp,LOCATION_ONFIELD,0,1,c,nil) end
    local sg=Duel.GetMatchingGroup(c14801903.filter2,tp,LOCATION_ONFIELD,0,c,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c14801903.desop2(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c14801903.filter2,tp,LOCATION_ONFIELD,0,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end