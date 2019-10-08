--阿拉德武装备 无影剑·艾雷诺
function c14801917.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c14801917.target)
    e1:SetOperation(c14801917.operation)
    c:RegisterEffect(e1)
    --Equip limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c14801917.eqlimit)
    c:RegisterEffect(e2)
    --Atk up
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(500)
    c:RegisterEffect(e3)
    --direct attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e4)
    --damage reduce
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e5:SetCondition(c14801917.rdcon)
    e5:SetOperation(c14801917.rdop)
    c:RegisterEffect(e5)
    --token
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(14801917,0))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e6:SetCountLimit(1,14801917)
    e6:SetCondition(c14801917.spcon)
    e6:SetTarget(c14801917.sptg)
    e6:SetOperation(c14801917.spop)
    c:RegisterEffect(e6)
end
function c14801917.eqlimit(e,c)
    return c:IsSetCard(0x480e)
end
function c14801917.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x480e)
end
function c14801917.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c14801917.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801917.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c14801917.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c14801917.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c14801917.rdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetEquipTarget()
    return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil
        and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c14801917.rdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev/2)
end
function c14801917.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c14801917.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c14801917.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,14801853,0,0x4011,2000,2000,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
        local token=Duel.CreateToken(tp,14801853)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end