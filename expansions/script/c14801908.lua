--使徒 长脚 罗特斯
function c14801908.initial_effect(c)
    c:EnableReviveLimit()
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801908,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP,1)
    e1:SetCondition(c14801908.spcons)
    e1:SetOperation(c14801908.spops)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801908,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP,0)
    e2:SetCondition(c14801908.spcon)
    e2:SetOperation(c14801908.spop)
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
    e4:SetTarget(c14801908.antarget)
    c:RegisterEffect(e4)
    --control
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801908,2))
    e5:SetCategory(CATEGORY_CONTROL)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c14801908.sccon)
    e5:SetTarget(c14801908.cttg2)
    e5:SetOperation(c14801908.ctop2)
    c:RegisterEffect(e5)
end
function c14801908.spfilters(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c14801908.spcons(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c14801908.spfilters,tp,0,LOCATION_MZONE,1,nil,tp)
end
function c14801908.spops(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c14801908.spfilters,tp,0,LOCATION_MZONE,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c14801908.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14801908.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801908.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler())
end
function c14801908.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801908.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801908.antarget(e,c)
    return not c:IsSetCard(0x480d)
end
function c14801908.sccon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function c14801908.ctfilter2(c,mc)
    return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c14801908.cttg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c14801908.ctfilter2(chkc,c) end
    if chk==0 then return Duel.IsExistingTarget(c14801908.ctfilter2,tp,0,LOCATION_MZONE,1,nil,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c14801908.ctfilter2,tp,0,LOCATION_MZONE,1,1,nil,c)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c14801908.ctop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_BATTLE,1)
    end
end