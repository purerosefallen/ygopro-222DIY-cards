--阿拉德 凯丽
function c14801972.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c14801972.lcheck,2,99)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801972,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,14801972)
    e1:SetTarget(c14801972.eqtg)
    e1:SetOperation(c14801972.eqop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801972,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,148019721)
    e2:SetCost(c14801972.spcost)
    e2:SetTarget(c14801972.sptg1)
    e2:SetOperation(c14801972.spop1)
    c:RegisterEffect(e2)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x480e))
    e3:SetCondition(c14801972.atkcon)
    e3:SetValue(c14801972.atkval)
    c:RegisterEffect(e3)
end
function c14801972.lcheck(c)
    return c:IsLinkSetCard(0x480e) or c:IsType(TYPE_TOKEN)
end
function c14801972.filter(c,ec)
    return c:IsSetCard(0x4809) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c14801972.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c14801972.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c14801972.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14801972,1))
    local g=Duel.SelectMatchingCard(tp,c14801972.filter,tp,LOCATION_DECK,0,1,1,nil,c)
    if g:GetCount()>0 then
        Duel.Equip(tp,g:GetFirst(),c)
    end
end
function c14801972.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c14801972.spfilter1(c,e,tp,zone)
    return c:IsRace(RACE_WARRIOR) and c:IsSetCard(0x480e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c14801972.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801972.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c14801972.spop1(e,tp,eg,ep,ev,re,r,rp)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or zone<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801972.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
function c14801972.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x4809)
end
function c14801972.atkfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c14801972.atkval(e,c)
    return Duel.GetMatchingGroupCount(c14801972.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*500
end