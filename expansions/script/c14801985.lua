--阿拉德 土罐
function c14801985.initial_effect(c)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801985,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetRange(LOCATION_HAND)
    e3:SetCondition(c14801985.hspcon)
    e3:SetTarget(c14801985.hsptg)
    e3:SetOperation(c14801985.hspop)
    c:RegisterEffect(e3)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801985,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c14801985.target)
    e2:SetOperation(c14801985.activate)
    c:RegisterEffect(e2)
end
function c14801985.hspcon(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c14801985.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and c:IsCanBeSpecialSummoned(e,114,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c14801985.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,114,tp,tp,false,false,POS_FACEUP)~=0 then
        local a=Duel.GetAttacker()
        if a:IsAttackable() and not a:IsImmuneToEffect(e) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
            e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetValue(1)
            e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
            c:RegisterEffect(e3)
            Duel.CalculateDamage(a,c)
        end
    end
end
function c14801985.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
        local g=Duel.GetDecktopGroup(tp,3)
        return g:FilterCount(Card.IsAbleToHand,nil)>0
    end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c14801985.filter(c)
    return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x4809)
end
function c14801985.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.ConfirmDecktop(p,3)
    local g=Duel.GetDecktopGroup(p,3)
    if g:GetCount()>0 then
        local sg=g:Filter(c14801985.filter,nil)
        if sg:GetCount()>0 then
            if sg:GetFirst():IsAbleToHand() then
                Duel.SendtoHand(sg,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-p,sg)
                Duel.ShuffleHand(p)
            else
                Duel.SendtoGrave(sg,REASON_EFFECT)
            end
        end
        Duel.ShuffleDeck(p)
    end
end