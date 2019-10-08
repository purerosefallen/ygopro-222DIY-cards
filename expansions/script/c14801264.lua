--白玉狐 竹意
function c14801264.initial_effect(c)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801264,1))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(c14801264.eqtg1)
    e1:SetOperation(c14801264.eqop1)
    c:RegisterEffect(e1)
    --destroy sub
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e2:SetValue(c14801264.repval)
    c:RegisterEffect(e2)
    --eqlimit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_EQUIP_LIMIT)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetValue(c14801264.eqlimit)
    c:RegisterEffect(e3)
    --Atk up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(500)
    c:RegisterEffect(e4)
    --Def up
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    e5:SetValue(500)
    c:RegisterEffect(e5)
    --
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e6:SetValue(1)
    c:RegisterEffect(e6)
        --search
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(14801264,0))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetTarget(c14801264.thtg)
    e7:SetOperation(c14801264.thop)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e8:SetRange(LOCATION_SZONE)
    e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e8:SetTarget(c14801264.eftg)
    e8:SetLabelObject(e7)
    c:RegisterEffect(e8)
    --search
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(14801264,2))
    e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_HAND)
    e9:SetCountLimit(1,14801264)
    e9:SetCost(c14801264.cost)
    e9:SetTarget(c14801264.target)
    e9:SetOperation(c14801264.operation)
    c:RegisterEffect(e9)
end
function c14801264.filter1(c)
    return c:IsSetCard(0x4802)
end
function c14801264.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c14801264.filter1(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c14801264.filter1,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c14801264.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c14801264.eqop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not tc:IsControler(tp) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(c14801264.eqlimit1)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
end
function c14801264.eqlimit1(e,c)
    return c==e:GetLabelObject()
end
function c14801264.repval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c14801264.eqlimit(e,c)
    return c:IsType(TYPE_MONSTER) or e:GetHandler():GetEquipTarget()==c
end
function c14801264.thfilter(c)
    return c:IsSetCard(0x480a) and c:IsAbleToHand()
end
function c14801264.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801264.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14801264.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801264.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c14801264.eftg(e,c)
    return e:GetHandler():GetEquipTarget()==c
end
function c14801264.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c14801264.filter2(c)
    return c:IsSetCard(0x4802) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c14801264.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801264.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c14801264.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c14801264.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end