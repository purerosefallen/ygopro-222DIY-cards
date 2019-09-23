--使徒 暴龙王 巴卡尔
function c14801912.initial_effect(c)
    c:EnableReviveLimit()
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801912,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP,1)
    e1:SetCondition(c14801912.spcons)
    e1:SetOperation(c14801912.spops)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801912,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e2:SetTargetRange(POS_FACEUP,0)
    e2:SetCondition(c14801912.spcon)
    e2:SetOperation(c14801912.spop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(c14801912.efilter)
    c:RegisterEffect(e3)
    --cannot attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_ATTACK)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(c14801912.antarget)
    c:RegisterEffect(e4)
    --to grave
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801912,2))
    e5:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c14801912.con)
    e5:SetTarget(c14801912.target)
    e5:SetOperation(c14801912.activate)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCountLimit(1)
    e6:SetCondition(c14801912.con2)
    e6:SetTarget(c14801912.target2)
    e6:SetOperation(c14801912.activate2)
    c:RegisterEffect(e6)
end
function c14801912.spfilters(c,tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function c14801912.spcons(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(c14801912.spfilters,tp,0,LOCATION_MZONE,2,nil,tp)
end
function c14801912.spops(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c14801912.spfilters,tp,0,LOCATION_MZONE,2,2,nil,tp)
    Duel.Release(g,REASON_COST)
end
function c14801912.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14801912.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801912.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,e:GetHandler())
end
function c14801912.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801912.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801912.efilter(e,re)
    return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function c14801912.antarget(e,c)
    return not c:IsSetCard(0x480d)
end
function c14801912.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c14801912.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    local gc=g:GetCount()
    if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(1-tp,gc) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,gc)
end
function c14801912.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    local gc=g:GetCount()
    if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
        local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if oc>0 then
            Duel.Draw(1-tp,oc,REASON_EFFECT)
        end
    end
end
function c14801912.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c14801912.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local gc=g:GetCount()
    if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(tp,gc) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function c14801912.activate2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    local gc=g:GetCount()
    if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
        local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        if oc>0 then
            Duel.Draw(tp,oc,REASON_EFFECT)
        end
    end
end