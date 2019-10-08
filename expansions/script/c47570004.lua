--死亡之翼
function c47570004.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(c47570004.condition)
    e1:SetTarget(c47570004.target)
    e1:SetOperation(c47570004.operation)
    c:RegisterEffect(e1)   
    --cataclysm
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,47570005)
    e2:SetCondition(c47570004.descon)
    e2:SetTarget(c47570004.destg)
    e2:SetOperation(c47570004.desop)
    c:RegisterEffect(e2)
end
function c47570004.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,2,nil)
end
function c47570004.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,nil)
end
function c47570004.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
    if Duel.Destroy(sg,REASON_EFFECT)~=0 then
        Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
    end
end
function c47570004.ctmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c47570004.ctmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47570004.ctmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47570004,0))
        if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,47570004,RESET_CHAIN,0,1) end
        local tc=Duel.SelectMatchingCard(tp,c47570004.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
        Duel.ResetFlagEffect(tp,47570004)
        if tc then
            local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
            if fc then
                Duel.SendtoGrave(fc,REASON_RULE)
                Duel.BreakEffect()
            end
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            local te=tc:GetActivateEffect()
            te:UseCountLimit(tp,1,true)
            local tep=tc:GetControler()
            local cost=te:GetCost()
            if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
            Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
        end        
    end
end