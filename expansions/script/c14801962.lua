--重力恶魔 白斯
function c14801962.initial_effect(c)
    --fusion summon
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c14801962.ffilter,2,false)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c14801962.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c14801962.spcon)
    e2:SetOperation(c14801962.spop)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --cannot attack announce
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CANNOT_ATTACK)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(c14801962.antarget)
    c:RegisterEffect(e4)
end
function c14801962.ffilter(c,fc,sub,mg,sg)
    return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_MZONE+LOCATION_HAND) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c14801962.splimit(e,se,sp,st)
    return not e:GetHandler():IsLocation(LOCATION_EXTRA)
        or st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function c14801962.cfilter(c,fc)
    return c:IsCanBeFusionMaterial(fc)
end
function c14801962.fselect(c,tp,mg,sg)
    sg:AddCard(c)
    local res=false
    if sg:GetCount()<2 then
        res=mg:IsExists(c14801962.fselect,1,sg,tp,mg,sg)
    elseif Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
        res=sg:GetClassCount(Card.GetFusionCode)==2
    end
    sg:RemoveCard(c)
    return res
end
function c14801962.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c14801962.cfilter,tp,LOCATION_MZONE,0,nil,c)
    local sg=Group.CreateGroup()
    return mg:IsExists(c14801962.fselect,1,nil,tp,mg,sg)
end
function c14801962.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c14801962.cfilter,tp,LOCATION_MZONE,0,nil,c)
    local sg=Group.CreateGroup()
    while sg:GetCount()<2 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g=mg:FilterSelect(tp,c14801962.fselect,1,1,sg,tp,mg,sg)
        sg:Merge(g)
    end
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c14801962.antarget(e,c,sump,sumtype,sumpos,targetp)
    return c:IsAttackAbove(3000)
end