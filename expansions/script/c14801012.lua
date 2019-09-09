--灾厄恐魔 杰顿
function c14801012.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x4800),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),true)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c14801012.sprcon)
    e1:SetOperation(c14801012.sprop)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e3)
    --remove
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801012,1))
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_END_PHASE)
    e4:SetCountLimit(1,14801012)
    e4:SetTarget(c14801012.rmtg)
    e4:SetOperation(c14801012.rmop)
    c:RegisterEffect(e4)
    --Activate
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCondition(c14801012.condition)
    e5:SetCost(aux.bfgcost)
    e5:SetTarget(c14801012.target)
    e5:SetOperation(c14801012.activate)
    c:RegisterEffect(e5)
end
function c14801012.cfilter(c,fc)
    return (c:IsFusionSetCard(0x4800) or c:IsFusionAttribute(ATTRIBUTE_LIGHT)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c14801012.spfilter1(c,tp,g)
    return g:IsExists(c14801012.spfilter2,1,c,tp,c)
end
function c14801012.spfilter2(c,tp,mc)
    return (c:IsFusionSetCard(0x4800) and mc:IsFusionAttribute(ATTRIBUTE_LIGHT)
        or c:IsFusionAttribute(ATTRIBUTE_LIGHT) and mc:IsFusionSetCard(0x4800))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c14801012.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c14801012.cfilter,tp,LOCATION_MZONE,0,nil,c)
    return mg:IsExists(c14801012.spfilter1,1,nil,tp,mg)
end
function c14801012.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c14801012.cfilter,tp,LOCATION_MZONE,0,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=mg:FilterSelect(tp,c14801012.spfilter1,1,1,nil,tp,mg)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=mg:FilterSelect(tp,c14801012.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_COST)
end
function c14801012.rmfilter(c)
    return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAbleToRemove()
        and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c14801012.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c14801012.rmfilter(chkc) end
    if chk==0 then return e:GetHandler():IsAbleToRemove()
        and Duel.IsExistingTarget(c14801012.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c14801012.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c14801012.rmop(e,tp,eg,ep,ev,re,r,rp)
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
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e2:SetCountLimit(1)
        e2:SetLabel(fid)
        e2:SetLabelObject(og)
        e2:SetCondition(c14801012.retcon)
        e2:SetOperation(c14801012.retop)
        if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
            e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
            e2:SetValue(Duel.GetTurnCount())
        else
            e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
            e2:SetValue(0)
        end
        Duel.RegisterEffect(e2,tp)
    end
end
function c14801012.retfilter(c,fid)
    return c:GetFlagEffectLabel(37192109)==fid
end
function c14801012.retcon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
    local g=e:GetLabelObject()
    if not g:IsExists(c14801012.retfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function c14801012.retop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local sg=g:Filter(c14801012.retfilter,nil,e:GetLabel())
    g:DeleteGroup()
    local tc=sg:GetFirst()
    while tc do
        Duel.ReturnToField(tc)
        tc=sg:GetNext()
    end
end
function c14801012.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c14801012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
    local dam=tg:GetAttack()
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c14801012.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.NegateAttack() then
            Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
        end
    end
end
