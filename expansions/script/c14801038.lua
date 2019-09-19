--灾厄升华
function c14801038.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(c14801038.target)
    e1:SetOperation(c14801038.activate)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetDescription(aux.Stringid(14801038,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,14801038)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c14801038.tdtg)
    e2:SetOperation(c14801038.tdop)
    c:RegisterEffect(e2)
end
function c14801038.tfilter(c,att,e,tp)
    return c:IsSetCard(0x480f) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c14801038.filter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x4800)
        and Duel.IsExistingMatchingCard(c14801038.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp)
        and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c14801038.chkfilter(c,att)
    return c:IsFaceup() and c:IsSetCard(0x4800) and (c:GetAttribute()&att)==att
end
function c14801038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c14801038.chkfilter(chkc,e:GetLabel()) end
    if chk==0 then return Duel.IsExistingTarget(c14801038.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,c14801038.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    e:SetLabel(g:GetFirst():GetAttribute())
end
function c14801038.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local att=tc:GetAttribute()
    if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,c14801038.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp)
    if sg:GetCount()>0 then
        Duel.BreakEffect()
        Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
        sg:GetFirst():CompleteProcedure()
    end
end

function c14801038.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c14801038.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
