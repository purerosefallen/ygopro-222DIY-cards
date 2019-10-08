--灾厄魔人 巴巴尔
function c14801020.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x4800),1)
    c:EnableReviveLimit()
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetTarget(c14801020.distg)
    c:RegisterEffect(e1)
    --copy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801020,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c14801020.copycost)
    e2:SetTarget(c14801020.copytg)
    e2:SetOperation(c14801020.copyop)
    c:RegisterEffect(e2)
    --destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetTarget(c14801020.reptg)
    c:RegisterEffect(e3)
end
function c14801020.distg(e,c)
    return c==e:GetHandler():GetBattleTarget()
end
function c14801020.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(14801020)==0 end
    e:GetHandler():RegisterFlagEffect(14801020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c14801020.copyfilter(c)
    return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c14801020.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c14801020.copyfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c14801020.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c14801020.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c14801020.copyop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
        local code=tc:GetOriginalCodeRule()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(code)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        if not tc:IsType(TYPE_TRAPMONSTER) then
            local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
            local e2=Effect.CreateEffect(c)
            e2:SetDescription(aux.Stringid(14801020,2))
            e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e2:SetCode(EVENT_PHASE+PHASE_END)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
            e2:SetCountLimit(1)
            e2:SetRange(LOCATION_MZONE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e2:SetLabelObject(e1)
            e2:SetLabel(cid)
            e2:SetOperation(c14801020.rstop)
            c:RegisterEffect(e2)
        end
        local atk=tc:GetAttack()
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(atk)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e3)
    end
end
function c14801020.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
    local e1=e:GetLabelObject()
    e1:Reset()
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c14801020.repfilter(c)
    return c:IsSetCard(0x4800) and c:IsAbleToRemove()
end
function c14801020.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
        and Duel.IsExistingMatchingCard(c14801020.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
        local g=Duel.SelectMatchingCard(tp,c14801020.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
        return true
    else return false end
end