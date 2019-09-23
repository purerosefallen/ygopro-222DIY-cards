--风之魔王兽 灾祸巴萨
function c14801201.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801201,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,148012011)
    e1:SetTarget(c14801201.drtg)
    e1:SetOperation(c14801201.drop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801201,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,14801201)
    e2:SetCondition(c14801201.spcon2)
    e2:SetTarget(c14801201.sptg2)
    e2:SetOperation(c14801201.spop2)
    c:RegisterEffect(e2)
end
function c14801201.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
    e:SetLabel(Duel.AnnounceType(tp))
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c14801201.drop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local d=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    Duel.ConfirmDecktop(1-tp,1)
    local g=Duel.GetDecktopGroup(1-tp,1)
    local tc=g:GetFirst()
    local opt=e:GetLabel()
    if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
        Duel.Draw(p,d,REASON_EFFECT)
    end  
end
function c14801201.spcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp))
        and c:IsPreviousPosition(POS_FACEUP)
end
function c14801201.spfilter2(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801201.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801201.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14801201.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c14801201.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2,true)
        Duel.SpecialSummonComplete()
        end
end