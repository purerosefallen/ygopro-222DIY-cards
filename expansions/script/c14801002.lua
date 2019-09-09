--灾厄岩兽 雷德王
function c14801002.initial_effect(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801002,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,14801002)
    e1:SetTarget(c14801002.thtg)
    e1:SetOperation(c14801002.thop)
    c:RegisterEffect(e1)
    local e4=e1:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801002,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,148010021)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetTarget(c14801002.sptg)
    e2:SetOperation(c14801002.spop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801002,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_REMOVE)
    e3:SetCountLimit(1,148010022)
    e3:SetTarget(c14801002.spbtg)
    e3:SetOperation(c14801002.spbop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c14801002.spbcon)
    c:RegisterEffect(e4)
end
function c14801002.thfilter(c)
    return c:IsSetCard(0x4800) and not c:IsCode(14801002) and c:IsAbleToHand()
end
function c14801002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14801002.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801002.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c14801002.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c14801002.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
function c14801002.thfilter1(c)
    return c:IsFaceup() and (c:IsSetCard(0x4800) and c:IsType(TYPE_MONSTER)) and c:IsAbleToGrave()
end
function c14801002.thfilter2(c)
    return c:IsFaceup() and (c:IsSetCard(0x4800) and c:IsType(TYPE_MONSTER)) and c:IsAbleToGrave() and c:GetSequence()<5
end
function c14801002.spfilter(c,e,tp)
    return c:IsSetCard(0x4800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then
        local b=false
        if ft>0 then
            b=Duel.IsExistingTarget(c14801002.thfilter1,tp,LOCATION_ONFIELD,0,1,nil)
        else
            b=Duel.IsExistingTarget(c14801002.thfilter2,tp,LOCATION_MZONE,0,1,nil)
        end
        return b and Duel.IsExistingTarget(c14801002.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    end
    local g1=nil
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    if ft>0 then
        g1=Duel.SelectTarget(tp,c14801002.thfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
    else
        g1=Duel.SelectTarget(tp,c14801002.thfilter2,tp,LOCATION_MZONE,0,1,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectTarget(tp,c14801002.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
    e:SetLabelObject(g1:GetFirst())
end
function c14801002.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc1,tc2=Duel.GetFirstTarget()
    if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
    if tc1:IsRelateToEffect(e) and Duel.SendtoGrave(tc1,REASON_EFFECT)>0
        and tc1:IsLocation(LOCATION_GRAVE) and tc2:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c14801002.spbcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function c14801002.spbfilter(c,e,tp)
    return c:IsSetCard(0x4800) and not c:IsCode(14801002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801002.spbtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14801002.spbfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c14801002.spbfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c14801002.spbfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c14801002.spbop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
