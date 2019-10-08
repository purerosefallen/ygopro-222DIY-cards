--阿拉德 雅尼斯
function c14801982.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c14801982.lcheck,2,2)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801982,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,14801982)
    e1:SetTarget(c14801982.eqtg)
    e1:SetOperation(c14801982.eqop)
    c:RegisterEffect(e1)
    --equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801982,2))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c14801982.target)
    e2:SetOperation(c14801982.operation)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetCondition(c14801982.indcon)
    e3:SetTarget(c14801982.indtg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
end
function c14801982.lcheck(c)
    return c:IsLinkSetCard(0x480e) or c:IsType(TYPE_TOKEN)
end
function c14801982.filter(c,ec)
    return c:IsSetCard(0x4809) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c14801982.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c14801982.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c14801982.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14801982,1))
    local g=Duel.SelectMatchingCard(tp,c14801982.filter,tp,LOCATION_DECK,0,1,1,nil,c)
    if g:GetCount()>0 then
        Duel.Equip(tp,g:GetFirst(),c)
    end
end
function c14801982.filter2(c,ec)
    return c:IsSetCard(0x4809) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c14801982.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c14801982.filter2,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c14801982.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,c14801982.filter2,tp,LOCATION_GRAVE,0,1,1,nil,c)
    local tc=g:GetFirst()
    if tc then
        Duel.Equip(tp,tc,c,true)
    end
end
function c14801982.indcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x4809)
end
function c14801982.indtg(e,c)
    return c:IsSetCard(0x480e)
end