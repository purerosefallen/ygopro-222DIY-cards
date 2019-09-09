--灾厄融合龙 奇美拉柏洛斯
function c14801061.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x4800),5,true)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.fuslimit)
    c:RegisterEffect(e1)
    --Immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --Equip
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801061,1))
    e5:SetCategory(CATEGORY_EQUIP)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(c14801061.eqtg)
    e5:SetOperation(c14801061.eqop)
    c:RegisterEffect(e5)
    --Destroy
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(14801061,2))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCost(c14801061.descost)
    e6:SetTarget(c14801061.destg)
    e6:SetOperation(c14801061.desop)
    c:RegisterEffect(e6)
end
function c14801061.filter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==1-tp
        and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsCanBeEffectTarget(e) and not c:IsForbidden()
end
function c14801061.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return eg:IsContains(chkc) and c14801061.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and eg:IsExists(c14801061.filter,1,nil,e,tp) end
    local g=eg:Filter(c14801061.filter,nil,e,tp)
    local tc=nil
    if g:GetCount()>1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        tc=g:Select(tp,1,1,nil):GetFirst()
    else
        tc=g:GetFirst()
    end
    Duel.SetTargetCard(tc)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c14801061.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        if not Duel.Equip(tp,tc,c,false) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c14801061.eqlimit)
        tc:RegisterEffect(e1)
    end
end
function c14801061.eqlimit(e,c)
    return e:GetOwner()==c
end
function c14801061.tgfilter(c,tp)
    return c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c14801061.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetRace())
end
function c14801061.desfilter(c,rc)
    return c:IsFaceup() and c:IsRace(rc)
end
function c14801061.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(c14801061.tgfilter,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,c14801061.tgfilter,1,1,nil,tp)
    e:SetLabel(g:GetFirst():GetRace())
    Duel.SendtoGrave(g,REASON_COST)
end
function c14801061.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c14801061.desfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c14801061.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c14801061.desfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
    Duel.Destroy(g,REASON_EFFECT)
end