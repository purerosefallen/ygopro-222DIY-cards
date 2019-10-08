--阿拉德 许愿Ⅰ
function c14801995.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,14801995+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c14801995.target)
    e1:SetOperation(c14801995.activate)
    c:RegisterEffect(e1)
end
function c14801995.filter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x480e)
        and Duel.IsExistingMatchingCard(c14801995.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c14801995.eqfilter(c,tc,tp)
    return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c14801995.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801995.filter(chkc,tp) end
    local ft=0
    if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
        and Duel.IsExistingTarget(c14801995.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c14801995.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c14801995.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c14801995.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
        if g:GetCount()>0 then
            Duel.Equip(tp,g:GetFirst(),tc)
        end
    end
end
