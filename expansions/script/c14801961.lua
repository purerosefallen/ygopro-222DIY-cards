--阿拉德大陆
function c14801961.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,14801961+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c14801961.activate)
    c:RegisterEffect(e1)
    --move
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801961,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c14801961.seqtg)
    e2:SetOperation(c14801961.seqop)
    c:RegisterEffect(e2)
    --Special Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801961,2))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCountLimit(1)
    e3:SetCondition(c14801961.effcon)
    e3:SetTarget(c14801961.drtg)
    e3:SetOperation(c14801961.drop)
    c:RegisterEffect(e3)
end
function c14801961.thfilter(c)
    return c:IsSetCard(0x480e) and c:IsAbleToHand()
end
function c14801961.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c14801961.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801961,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c14801961.seqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x480e)
end
function c14801961.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801961.seqfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801961.seqfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14801961,2))
    Duel.SelectTarget(tp,c14801961.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c14801961.seqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(tc,nseq)
end
function c14801961.confilter(c)
    return c:IsFaceup() and c:IsSetCard(0x480e)
end
function c14801961.effcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c14801961.filter(c)
    return c:IsSetCard(0x480e) and c:IsAbleToDeck()
end
function c14801961.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14801961.filter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(c14801961.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c14801961.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c14801961.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==5 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end