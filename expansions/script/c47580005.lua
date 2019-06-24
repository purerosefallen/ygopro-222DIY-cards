--全装要塞龙
function c47580005.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
    c:EnableReviveLimit()
    --indestructable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c47580005.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetValue(aux.indoval)
    c:RegisterEffect(e2)    
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47580005,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c47580005.spcon)
    e4:SetTarget(c47580005.sptg)
    e4:SetOperation(c47580005.spop)
    c:RegisterEffect(e4)
    --destroy
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47580005,1))
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e5:SetCountLimit(1)
    e5:SetTarget(c47580005.destg2)
    e5:SetOperation(c47580005.desop2)
    c:RegisterEffect(e5)
end
function c47580005.indtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c47580005.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c47580005.filter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47580005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c47580005.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47580005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c47580005.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetChainLimit(c47580005.chlimit)
end
function c47580005.chlimit(e,ep,tp)
    return tp==ep
end
function c47580005.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=1 then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
        tc:RegisterFlagEffect(47580005,RESET_EVENT+RESETS_STANDARD,0,1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetLabelObject(tc)
        e2:SetCondition(c47580005.descon)
        e2:SetOperation(c47580005.desop)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e2:SetCountLimit(1)
        Duel.RegisterEffect(e2,tp)
        tc=g:GetNext()
    end
    Duel.SpecialSummonComplete()
end
function c47580005.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffect(47580005)~=0 then
        return true
    else
        e:Reset()
        return false
    end
end
function c47580005.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c47580005.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,2,0,0)
end
function c47580005.desop2(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsControler,nil,1-tp)
    local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsControler,nil,tp)
    Duel.Destroy(g1,REASON_EFFECT)
    local tc=g2:GetFirst()
    if not tc:IsRelateToEffect(e) then return end
    Duel.BreakEffect()
    Duel.Destroy(tc,REASON_EFFECT)
end