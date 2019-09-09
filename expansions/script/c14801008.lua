--灾厄怪鸟 巴顿
function c14801008.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x4800),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),true)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c14801008.sprcon)
    e1:SetOperation(c14801008.sprop)
    c:RegisterEffect(e1)
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801008,0))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetTarget(c14801008.damtg)
    e2:SetOperation(c14801008.damop)
    c:RegisterEffect(e2)
    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_TO_HAND)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c14801008.damcon1)
    e3:SetOperation(c14801008.damop1)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_TO_HAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c14801008.regcon)
    e4:SetOperation(c14801008.regop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e5:SetCode(EVENT_CHAIN_SOLVED)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c14801008.damcon2)
    e5:SetOperation(c14801008.damop2)
    c:RegisterEffect(e5)
    --Activate
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DAMAGE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetCondition(aux.exccon)
    e6:SetCost(aux.bfgcost)
    e6:SetTarget(c14801008.target)
    e6:SetOperation(c14801008.activate)
    c:RegisterEffect(e6)
end
function c14801008.cfilter(c,fc)
    return (c:IsFusionSetCard(0x4800) or c:IsFusionAttribute(ATTRIBUTE_FIRE)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c14801008.spfilter1(c,tp,g)
    return g:IsExists(c14801008.spfilter2,1,c,tp,c)
end
function c14801008.spfilter2(c,tp,mc)
    return (c:IsFusionSetCard(0x4800) and mc:IsFusionAttribute(ATTRIBUTE_FIRE)
        or c:IsFusionAttribute(ATTRIBUTE_FIRE) and mc:IsFusionSetCard(0x4800))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c14801008.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c14801008.cfilter,tp,LOCATION_MZONE,0,nil,c)
    return mg:IsExists(c14801008.spfilter1,1,nil,tp,mg)
end
function c14801008.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c14801008.cfilter,tp,LOCATION_MZONE,0,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=mg:FilterSelect(tp,c14801008.spfilter1,1,1,nil,tp,mg)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=mg:FilterSelect(tp,c14801008.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_COST)
end
function c14801008.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
    local atk=g:GetFirst():GetAttack()
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
end
function c14801008.damop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local atk=tc:GetAttack()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atk/2)
        tc:RegisterEffect(e1)
        Duel.Damage(1-tp,atk/2,REASON_EFFECT)
    end
end
function c14801008.damcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp) and not c14801008.chain_solving
end
function c14801008.damop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,14801008)
    local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
    Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end
function c14801008.regcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsControler,1,nil,1-tp) and c14801008.chain_solving
end
function c14801008.regop(e,tp,eg,ep,ev,re,r,rp)
    local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
    e:GetHandler():RegisterFlagEffect(14801008,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ct)
end
function c14801008.damcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(14801008)>0
end
function c14801008.damop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,14801008)
    local labels={e:GetHandler():GetFlagEffectLabel(14801008)}
    local ct=0
    for i=1,#labels do ct=ct+labels[i] end
    e:GetHandler():ResetFlagEffect(14801008)
    Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end
function c14801008.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0xe,1,nil) end
    Duel.SetTargetPlayer(1-tp)
    local dam=Duel.GetFieldGroupCount(1-tp,0xe,0)*200
    Duel.SetTargetParam(dam)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c14801008.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local dam=Duel.GetFieldGroupCount(1-tp,0xe,0)*200
    Duel.Damage(p,dam,REASON_EFFECT)
end
