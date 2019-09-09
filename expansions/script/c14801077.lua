--灾厄重升华
function c14801077.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCost(c14801077.cost)
    e1:SetTarget(c14801077.target)
    e1:SetOperation(c14801077.activate)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetDescription(aux.Stringid(14801077,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,14801077)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c14801077.tdtg)
    e2:SetOperation(c14801077.tdop)
    c:RegisterEffect(e2)
end
function c14801077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c14801077.filter(c,e,tp)
    local lv=c:GetLevel()
    local att=c:GetAttribute()
    return lv>0 and c:IsFaceup()
        and Duel.IsExistingMatchingCard(c14801077.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv,att)
        and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c14801077.spfilter(c,e,tp,lv,att)
    return c:IsSetCard(0x480f) and c:GetLevel()>lv and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c14801077.chkfilter(c,tc)
    local lv=tc:GetLevel()
    local att=tc:GetAttribute()
    return c:IsFaceup() and c:IsLevelBelow(lv) and (c:GetAttribute()&att)==att
end
function c14801077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c14801077.chkfilter(chkc,e:GetLabelObject()) end
    if chk==0 then return Duel.IsExistingTarget(c14801077.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,c14801077.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    e:SetLabelObject(g:GetFirst())
end
function c14801077.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
    if not tc:IsRelateToEffect(e) then return end
    local att=tc:GetAttribute()
    local lv=tc:GetLevel()
    if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801077.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv,att)
    if g:GetCount()>0 then
        Duel.BreakEffect()
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
        g:GetFirst():CompleteProcedure()
    end
end
function c14801077.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c14801077.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end