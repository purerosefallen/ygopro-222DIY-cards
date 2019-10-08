--阿拉德 通往魔界之门
function c14801999.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,14801999+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c14801999.target)
    e1:SetOperation(c14801999.activate)
    c:RegisterEffect(e1)
end
function c14801999.filter(c)
    return c:IsSetCard(0x4809) and c:IsType(TYPE_EQUIP) and c:IsAbleToDeck()
end
function c14801999.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14801999.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801999.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c14801999.filter,tp,LOCATION_GRAVE,0,1,99,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*200)
end
function c14801999.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    if ct>0 then
        Duel.Recover(tp,ct*200,REASON_EFFECT)
    end
end
