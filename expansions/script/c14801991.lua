--阿拉德 诺羽
function c14801991.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,14801991)
    e1:SetCondition(c14801991.spcon)
    e1:SetOperation(c14801991.spop)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --level change
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c14801991.lvcon)
    e2:SetOperation(c14801991.lvop)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801991,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c14801991.spcon2)
    e3:SetTarget(c14801991.sptg2)
    e3:SetOperation(c14801991.spop2)
    c:RegisterEffect(e3)
    --to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801991,0))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetCountLimit(1,148019911)
    e4:SetTarget(c14801991.thtg)
    e4:SetOperation(c14801991.thop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
end
function c14801991.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c14801991.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801991.cfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c14801991.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c14801991.cfilter,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabel(g:GetFirst():GetLevel())
end
function c14801991.lvcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c14801991.lvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_LEVEL)
    e1:SetValue(-e:GetLabelObject():GetLabel())
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    c:RegisterEffect(e1)
end
function c14801991.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x4809)
end
function c14801991.filter(c,e,tp)
    return c:IsSetCard(0x480e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c14801991.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c14801991.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c14801991.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801991.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end
function c14801991.thfilter(c)
    return c:IsSetCard(0x4809) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c14801991.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801991.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14801991.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801991.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end