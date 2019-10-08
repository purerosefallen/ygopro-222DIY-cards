--阿拉德武装备 天选之剑·格朗
function c14801935.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c14801935.target)
    e1:SetOperation(c14801935.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c14801935.eqlimit)
    c:RegisterEffect(e2)
    --Atk up
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(600)
    c:RegisterEffect(e3)
    --negate
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetRange(LOCATION_SZONE)
    e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e4:SetCountLimit(1)
    e4:SetCondition(c14801935.negcon)
    e4:SetTarget(c14801935.negtg)
    e4:SetOperation(c14801935.negop)
    c:RegisterEffect(e4)
    --token
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801935,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e5:SetCountLimit(1,14801935)
    e5:SetCondition(c14801935.spcon)
    e5:SetTarget(c14801935.sptg)
    e5:SetOperation(c14801935.spop)
    c:RegisterEffect(e5)
end
function c14801935.eqlimit(e,c)
    return c:IsRace(RACE_WARRIOR) and c:IsSetCard(0x480e)
end
function c14801935.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsSetCard(0x480e)
end
function c14801935.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c14801935.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801935.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c14801935.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c14801935.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c14801935.negcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_SZONE
        and re:IsActiveType(TYPE_TRAP) and Duel.IsChainDisablable(ev)
end
function c14801935.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(14801934,1))
end
function c14801935.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,14801935)
    Duel.NegateEffect(ev)
end
function c14801935.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c14801935.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c14801935.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,14801871,0,0x4011,2000,2000,4,RACE_WARRIOR,ATTRIBUTE_EARTH) then
        local token=Duel.CreateToken(tp,14801871)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end