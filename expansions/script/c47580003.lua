--自律引导扇区
function c47580003.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47580003,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(c47580003.spcon)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,47580003)
    e2:SetTarget(c47580003.sptg)
    e2:SetOperation(c47580003.spop)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47580003,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1,47580003)
    e3:SetCondition(c47580003.spcon2)
    e3:SetTarget(c47580003.sptg2)
    e3:SetOperation(c47580003.spop2)
    c:RegisterEffect(e3)
end
function c47580003.filter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_LINK)
end
function c47580003.spfilter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c47580003.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c47580003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47580003.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47580003.filter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c47580003.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47580003.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c47580003.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),tc:GetLink())
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47580003.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,tp)
    local tc=g:GetFirst()
    while tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) do
        tc:RegisterFlagEffect(47580003,RESET_EVENT+RESETS_STANDARD,0,1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetLabelObject(tc)
        e2:SetCondition(c47580003.descon)
        e2:SetOperation(c47580003.desop)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e2:SetCountLimit(1)
        Duel.RegisterEffect(e2,tp)
        Duel.SpecialSummonComplete()
        tc=g:GetNext()
    end
end
function c47580003.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffect(47580003)~=0 then
        return true
    else
        e:Reset()
        return false
    end
end
function c47580003.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c47580003.cfilter(c)
    return not (c:IsType(TYPE_LINK) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c47580003.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c47580003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47580003.spfilter2(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsLevelBelow(4) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c47580003.fcheck(c,g)
    return g:IsExists(Card.IsOriginalCodeRule,1,c,c:GetOriginalCodeRule())
end
function c47580003.fselect(g)
    return g:GetClassCount(Card.GetLocation)==g:GetCount() and not g:IsExists(c47580003.fcheck,1,nil,g)
end
function c47580003.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c47580003.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    if chk==0 then return g:CheckSubGroup(c47580003.fselect,3,3) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c47580003.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c47580003.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=g:SelectSubGroup(tp,c47580003.fselect,false,3,3)
    if sg and sg:GetCount()==3 then
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
    end
end