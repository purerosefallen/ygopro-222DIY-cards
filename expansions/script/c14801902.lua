--使徒 哭泣之眼 赫尔德
function c14801902.initial_effect(c)
    c:EnableReviveLimit()
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801902,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP,1)
    e1:SetCondition(c14801902.spcons)
    e1:SetOperation(c14801902.spops)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801902,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP,0)
    e2:SetCondition(c14801902.spcon)
    e2:SetOperation(c14801902.spop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c14801902.efilter)
    c:RegisterEffect(e3)
    --cannot attack
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_ATTACK)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c14801902.antarget)
    c:RegisterEffect(e5)
    --control
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(14801902,2))
    e6:SetCategory(CATEGORY_CONTROL)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetTarget(c14801902.cttg2)
    e6:SetOperation(c14801902.ctop2)
    c:RegisterEffect(e6)
end
function c14801902.spfilters(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c14801902.spcons(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c14801902.spfilters,tp,0,LOCATION_MZONE,3,nil,tp)
end
function c14801902.spops(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c14801902.spfilters,tp,0,LOCATION_MZONE,3,3,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c14801902.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14801902.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801902.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,3,e:GetHandler())
end
function c14801902.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801902.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,3,3,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801902.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c14801902.antarget(e,c)
    return not c:IsSetCard(0x480d)
end
function c14801902.ctfilter2(c,mc)
    return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c14801902.cttg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c14801902.ctfilter2(chkc,c) end
    if chk==0 then return Duel.IsExistingTarget(c14801902.ctfilter2,tp,0,LOCATION_MZONE,1,nil,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c14801902.ctfilter2,tp,0,LOCATION_MZONE,1,1,nil,c)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c14801902.ctop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end