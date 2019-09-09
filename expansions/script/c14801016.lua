--灾厄磁虫 安东拉
function c14801016.initial_effect(c)
    --extra summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801016,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e1)
    local e5=e1:Clone()
    e5:SetCode(EFFECT_EXTRA_SET_COUNT)
    c:RegisterEffect(e5)
    --cannot select battle target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e2:SetValue(c14801016.atlimit)
    c:RegisterEffect(e2)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801016,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_REMOVE)
    e3:SetCountLimit(1,14801016)
    e3:SetTarget(c14801016.thtg)
    e3:SetOperation(c14801016.thop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c14801016.thcon)
    c:RegisterEffect(e4)
end
function c14801016.atlimit(e,c)
    return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x4800)
end
function c14801016.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function c14801016.thfilter(c)
    return c:IsSetCard(0x4800) and not c:IsCode(14801006) and c:IsAbleToHand()
end
function c14801016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801016.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14801016.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801016.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end