--星晶融合
local m=47511101
local cm=_G["c"..m]
function c47511101.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47511101+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c47511101.target)
    e1:SetOperation(c47511101.activate)
    c:RegisterEffect(e1) 
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c47511101.discon)
    e2:SetOperation(c47511101.disop)
    c:RegisterEffect(e2)  
end
c47511101.list={
        CATEGORY_DESTROY,
        CATEGORY_RELEASE,
        CATEGORY_REMOVE,
        CATEGORY_TOHAND,
        CATEGORY_TODECK,
        CATEGORY_TOGRAVE,
        CATEGORY_DECKDES,
        CATEGORY_HANDES,
        CATEGORY_POSITION,
        CATEGORY_CONTROL,
        CATEGORY_DISABLE,
        CATEGORY_DISABLE_SUMMON,
        CATEGORY_EQUIP,
        CATEGORY_DAMAGE,
        CATEGORY_RECOVER,
        CATEGORY_ATKCHANGE,
        CATEGORY_DEFCHANGE,
        CATEGORY_COUNTER,
        CATEGORY_LVCHANGE,
        CATEGORY_NEGATE,
}
function c47511101.nfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c47511101.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():GetFlagEffect(47510255)~=0 then return end
    if not rp==1-tp then return end
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
    if c47511101.nfilter(re:GetHandler()) then return true end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if g and g:IsExists(c47511101.nfilter,1,nil) then return true end
    local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
    if res and ceg and ceg:IsExists(c47511101.nfilter,1,nil) then return true end
    for i,ctg in pairs(c47511101.list) do
        local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
        if tg then
            if tg:IsExists(c47511101.nfilter,1,c) then return true end
        elseif v and v>0 and Duel.IsExistingMatchingCard(c47511101.nfilter,tp,v,0,1,nil) then
            return true
        end
    end
    return false
end
function c47511101.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.NegateEffect(ev)
    Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end
function c47511101.filter1(c,e)
    return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c47511101.filter0(c,e)
    return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c47511101.exfilter0(c)
    return c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and c:IsFaceup()
end
function c47511101.exfilter1(c,e)
    return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c47511101.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsType(TYPE_PENDULUM) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c47511101.fcheck(tp,sg,fc)
    return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=2
end
function c47511101.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
        local sg=Duel.GetMatchingGroup(c47511101.exfilter0,tp,LOCATION_EXTRA,0,nil)
            if sg:GetCount()>0 then
                mg1:Merge(sg)
                Auxiliary.FCheckAdditional=c47511101.fcheck
            end
        local res=Duel.IsExistingMatchingCard(c47511101.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        Auxiliary.FCheckAdditional=nil
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c47511101.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47511101.activate(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c47511101.filter1,nil,e)
    local exmat=false
        local sg=Duel.GetMatchingGroup(c47511101.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
        if sg:GetCount()>0 then
            mg1:Merge(sg)
            exmat=true
        end
    if exmat then Auxiliary.FCheckAdditional=c47511101.fcheck end
    local sg1=Duel.GetMatchingGroup(c47511101.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    Auxiliary.FCheckAdditional=nil
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c47511101.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        mg1:RemoveCard(tc)
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            if exmat then Auxiliary.FCheckAdditional=c47511101.fcheck end
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
            Auxiliary.FCheckAdditional=nil
            tc:SetMaterial(mat1)
            Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end