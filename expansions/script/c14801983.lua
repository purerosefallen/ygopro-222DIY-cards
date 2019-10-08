--阿拉德 莱诺
function c14801983.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c14801983.lcheck,2,2)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801983,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,14801983)
    e1:SetTarget(c14801983.eqtg)
    e1:SetOperation(c14801983.eqop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801983,2))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c14801983.con)
    e2:SetTarget(c14801983.target)
    e2:SetOperation(c14801983.operation)
    c:RegisterEffect(e2)
    --equip change
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801983,3))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetTarget(c14801983.eqtg2)
    e3:SetOperation(c14801983.eqop2)
    c:RegisterEffect(e3)
end
function c14801983.lcheck(c)
    return c:IsLinkSetCard(0x480e) or c:IsType(TYPE_TOKEN)
end
function c14801983.filter(c,ec)
    return c:IsSetCard(0x4809) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c14801983.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c14801983.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c14801983.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14801983,1))
    local g=Duel.SelectMatchingCard(tp,c14801983.filter,tp,LOCATION_DECK,0,1,1,nil,c)
    if g:GetCount()>0 then
        Duel.Equip(tp,g:GetFirst(),c)
    end
end
function c14801983.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x4809)
end
function c14801983.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
    if chk==0 then return #g>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c14801983.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function c14801983.eqfilter1(c)
    return c:IsSetCard(0x4809) and c:GetEquipTarget()
        and Duel.IsExistingTarget(c14801983.eqfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c:GetEquipTarget(),c)
end
function c14801983.eqfilter2(c,ec)
    return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function c14801983.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c14801983.eqfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g1=Duel.SelectTarget(tp,c14801983.eqfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
    local tc=g1:GetFirst()
    e:SetLabelObject(tc)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g2=Duel.SelectTarget(tp,c14801983.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc:GetEquipTarget(),tc)
end
function c14801983.eqop2(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetLabelObject()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tc=g:GetFirst()
    if tc==ec then tc=g:GetNext() end
    if ec:IsFaceup() and ec:IsRelateToEffect(e) and ec:CheckEquipTarget(tc) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.Equip(tp,ec,tc)
    end
end