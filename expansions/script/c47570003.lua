--恩佐斯的呼唤
function c47570003.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47570003+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c47570003.target)
    e1:SetOperation(c47570003.activate)
    c:RegisterEffect(e1)   
    --Call of N'zoth
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,47570004)
    e2:SetCondition(c47570003.checon)
    e2:SetCost(c47570003.checost)
    e2:SetTarget(c47570003.chetg)
    e2:SetOperation(c47570003.cheop)
    c:RegisterEffect(e2) 
end
function c47570003.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47570003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c47570003.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47570003.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47570003.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,1-tp,LOCATION_MZONE)
end
function c47570003.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e1:SetTargetRange(0xff,0xff)
        e1:SetTarget(c47570003.chtg)
        e1:SetLabelObject(tc)
        e1:SetValue(ATTRIBUTE_DARK)
        e1:SetReset(RESET_PHASE+PHASE_END,2)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CHANGE_RACE)
        e2:SetValue(RACE_FAIRY)
        Duel.RegisterEffect(e2,tp)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        Duel.RegisterEffect(e3,tp)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UNRELEASABLE_SUM)
        Duel.RegisterEffect(e4,tp)
        local e5=e1:Clone()
        e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
        e5:SetValue(c47570003.fuslimit)
        Duel.RegisterEffect(e5,tp)
        local e6=e1:Clone()
        e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
        Duel.RegisterEffect(e6,tp)
        local e7=e1:Clone()
        e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
        Duel.RegisterEffect(e7,tp)     
    end
end
function c47570003.fuslimit(e,c,sumtype)
    return sumtype==SUMMON_TYPE_FUSION
end  
function c47570003.chtg(e,c)
    local tc=e:GetLabelObject()
    return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c47570003.checon(e,tp,eg,ep,ev,re,r,rp)
    local ex=Duel.GetOperationInfo(ev,CATEGORY_CONTROL)
    local ex2=re:IsHasCategory(CATEGORY_CONTROL)
    return (ex or ex2) and Duel.IsChainDisablable(ev)
end
function c47570003.checost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() end
    Duel.Remove(c,REASON_COST)
end
function c47570003.chfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler()
end
function c47570003.chetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47570003.chfilter,rp,0,LOCATION_MZONE,1,nil) end
end
function c47570003.cheop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c47570003.repop)
end
function c47570003.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c47570003.repop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local ct=g:GetCount()
    if ft<ct then return end
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        Duel.GetControl(tc,1-tp)
        tc=g:GetNext()
    end
end