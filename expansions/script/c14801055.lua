--灾厄融合兽 雷霆杀手
function c14801055.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)
    --handes
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(14801003,1))
    e1:SetCategory(CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetCondition(c14801003.condition)
    e1:SetTarget(c14801003.target)
    e1:SetOperation(c14801003.operation)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801003,0))
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetTarget(c14801003.distg)
    e2:SetOperation(c14801003.disop)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetValue(aux.tgoval)
    c:RegisterEffect(e4)
end
function c14801003.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c14801003.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c14801003.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
    local sg=g:RandomSelect(ep,1)
    Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c14801003.disfilter(c)
    return c:IsFaceup() and not (c:GetAttack()==0 and c:IsDisabled())
end
function c14801003.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c14801003.disfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801003.disfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c14801003.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c14801003.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        e3:SetValue(RESET_TURN_SET)
        e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e4=Effect.CreateEffect(c)
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e4)
        end
    end
end