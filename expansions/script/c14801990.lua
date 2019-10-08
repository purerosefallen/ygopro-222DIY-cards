--阿拉德 小铁柱
function c14801990.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801990,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,14801990)
    e1:SetCondition(c14801990.sprcon)
    c:RegisterEffect(e1)
    --extra summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801990,1))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x480e))
    c:RegisterEffect(e3)
    --search
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801990,2))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c14801990.con2)
    e5:SetTarget(c14801990.target2)
    e5:SetOperation(c14801990.operation2)
    c:RegisterEffect(e5)
end
function c14801990.sprfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4809) and c:GetType()==TYPE_SPELL+TYPE_EQUIP
end
function c14801990.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801990.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c14801990.con2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x4809)
end
function c14801990.filter2(c)
    return c:IsSetCard(0x480e) and c:IsAbleToHand()
end
function c14801990.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801990.filter2,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c14801990.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801990.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end