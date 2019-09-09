--灾厄异兽 布鲁顿
function c14801005.initial_effect(c)
    --negate attack
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801005,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c14801005.dimcom)
    e1:SetTarget(c14801005.dimtg)
    e1:SetOperation(c14801005.dimop)
    c:RegisterEffect(e1)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(899287,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,14801005)
    e2:SetTarget(c14801005.destg)
    e2:SetOperation(c14801005.desop)
    c:RegisterEffect(e2)
    local e5=e2:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801005,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_REMOVE)
    e3:SetCountLimit(1,148010051)
    e3:SetTarget(c14801005.thtg)
    e3:SetOperation(c14801005.thop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c14801005.thcon)
    c:RegisterEffect(e4)
end
function c14801005.dimfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4800)
end
function c14801005.dimcom(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:GetControler()==1-tp and Duel.IsExistingMatchingCard(c14801005.dimfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c14801005.dimtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c14801005.dimop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.NegateAttack()
    end
end
function c14801005.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c14801005.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c14801005.filter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c14801005.filter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c14801005.filter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c14801005.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c14801005.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function c14801005.thfilter(c)
    return c:IsSetCard(0x4800) and not c:IsCode(c14801005) and c:IsAbleToHand()
end
function c14801005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801005.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14801005.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
