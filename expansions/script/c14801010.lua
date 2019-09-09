 --灾厄深渊 古维拉
function c14801010.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x4800),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WATER),true)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c14801010.sprcon)
    e1:SetOperation(c14801010.sprop)
    c:RegisterEffect(e1)
    --pierce
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801010,0))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCountLimit(1)
    e3:SetCondition(c14801010.discon)
    e3:SetTarget(c14801010.distg)
    e3:SetOperation(c14801010.disop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_SZONE)
    c:RegisterEffect(e4)
    --pos
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_POSITION)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCondition(aux.exccon)
    e5:SetCost(aux.bfgcost)
    e5:SetTarget(c14801010.postg)
    e5:SetOperation(c14801010.posop)
    c:RegisterEffect(e5)
end
function c14801010.cfilter(c,fc)
    return (c:IsFusionSetCard(0x4800) or c:IsFusionAttribute(ATTRIBUTE_WATER)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c14801010.spfilter1(c,tp,g)
    return g:IsExists(c14801010.spfilter2,1,c,tp,c)
end
function c14801010.spfilter2(c,tp,mc)
    return (c:IsFusionSetCard(0x4800) and mc:IsFusionAttribute(ATTRIBUTE_WATER)
        or c:IsFusionAttribute(ATTRIBUTE_WATER) and mc:IsFusionSetCard(0x4800))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c14801010.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c14801010.cfilter,tp,LOCATION_MZONE,0,nil,c)
    return mg:IsExists(c14801010.spfilter1,1,nil,tp,mg)
end
function c14801010.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c14801010.cfilter,tp,LOCATION_MZONE,0,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=mg:FilterSelect(tp,c14801010.spfilter1,1,1,nil,tp,mg)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=mg:FilterSelect(tp,c14801010.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_COST)
end
function c14801010.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c14801010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c14801010.disop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c14801010.filter(c)
    return c:IsCanChangePosition()
end
function c14801010.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c14801010.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,c14801010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c14801010.posop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end