--白玉 红叶
function c14801254.initial_effect(c)
    --direct attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e1)
    --to grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801254,0))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLED)
    e2:SetTarget(c14801254.tg)
    e2:SetOperation(c14801254.op)
    c:RegisterEffect(e2)
    --Special Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801254,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,14801254)
    e3:SetCondition(c14801254.sscon)
    e3:SetTarget(c14801254.sstg)
    e3:SetOperation(c14801254.ssop)
    c:RegisterEffect(e3)
end
function c14801254.filter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x4802)
end
function c14801254.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801254.filter,tp,LOCATION_ONFIELD,0,1,nil) end
    local ct=Duel.GetMatchingGroupCount(c14801254.filter,tp,LOCATION_ONFIELD,0,nil)
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(ct*500)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c14801254.op(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=Duel.GetMatchingGroupCount(c14801254.filter,tp,LOCATION_ONFIELD,0,nil)
    Duel.Damage(p,ct*500,REASON_EFFECT)
end
function c14801254.filter2(c)
    return c:IsFaceup() and  c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x480a)
end
function c14801254.sscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c14801254.filter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c14801254.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14801254.ssop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end