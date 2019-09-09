--灾厄融合兽 佩丹尼姆杰顿
function c14801056.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)
    --atk/def
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c14801056.val)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
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
    --remove
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(14801056,1))
    e5:SetCategory(CATEGORY_REMOVE)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_END_PHASE)
    e5:SetCountLimit(1,14801056)
    e5:SetTarget(c14801056.rmtg)
    e5:SetOperation(c14801056.rmop)
    c:RegisterEffect(e5)
end
function c14801056.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x4800)
end
function c14801056.val(e,c)
    return Duel.GetMatchingGroupCount(c14801056.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*300
end
function c14801056.rmfilter(c)
    return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAbleToRemove()
        and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c14801056.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c14801056.rmfilter(chkc) end
    if chk==0 then return e:GetHandler():IsAbleToRemove()
        and Duel.IsExistingTarget(c14801056.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c14801056.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c14801056.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
    local g=Group.FromCards(c,tc)
    if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
        local fid=c:GetFieldID()
        local rct=1
        if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then rct=2 end
        local og=Duel.GetOperatedGroup()
        local oc=og:GetFirst()
        while oc do
            if oc:IsControler(tp) then
                oc:RegisterFlagEffect(37192109,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,rct,fid)
            else
                oc:RegisterFlagEffect(37192109,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,0,rct,fid)
            end
            oc=og:GetNext()
        end
        og:KeepAlive()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e1:SetCountLimit(1)
        e1:SetLabel(fid)
        e1:SetLabelObject(og)
        e1:SetCondition(c14801056.retcon)
        e1:SetOperation(c14801056.retop)
        if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
            e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
            e1:SetValue(Duel.GetTurnCount())
        else
            e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
            e1:SetValue(0)
        end
        Duel.RegisterEffect(e1,tp)
    end
end
function c14801056.retfilter(c,fid)
    return c:GetFlagEffectLabel(37192109)==fid
end
function c14801056.retcon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
    local g=e:GetLabelObject()
    if not g:IsExists(c14801056.retfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function c14801056.retop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local sg=g:Filter(c14801056.retfilter,nil,e:GetLabel())
    g:DeleteGroup()
    local tc=sg:GetFirst()
    while tc do
        Duel.ReturnToField(tc)
        tc=sg:GetNext()
    end
end