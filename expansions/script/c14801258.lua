--白玉 黑蜜大树
function c14801258.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,14801258+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c14801258.activate)
    c:RegisterEffect(e1)
    --to grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801258,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLED)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c14801258.tg)
    e2:SetOperation(c14801258.op)
    c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4802))
    e3:SetValue(500)
    c:RegisterEffect(e3)
end
function c14801258.thfilter(c)
    return c:IsSetCard(0x4802) and c:IsAbleToHand()
end
function c14801258.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c14801258.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(14801258,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c14801258.filter(c,e,tp)
    return c:IsSetCard(0x4802) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801258.check(c,tp)
    return c and c:IsControler(tp) and c:IsSetCard(0x4802)
end
function c14801258.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetAttackTarget()~=nil
        and (c14801258.check(Duel.GetAttacker(),tp) or c14801258.check(Duel.GetAttackTarget(),tp)) end
    if c14801258.check(Duel.GetAttacker(),tp) then
        Duel.SetTargetCard(Duel.GetAttackTarget())
    else
        Duel.SetTargetCard(Duel.GetAttacker())
    end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c14801258.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14801258.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c14801258.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
end