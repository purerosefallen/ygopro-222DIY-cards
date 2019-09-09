--灾厄冥硫 霍
function c14801013.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x4800),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),true)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c14801013.sprcon)
    e1:SetOperation(c14801013.sprop)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c14801013.value)
    c:RegisterEffect(e2)
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(14801013,0))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c14801013.cost)
    e3:SetTarget(c14801013.destg)
    e3:SetOperation(c14801013.desop)
    c:RegisterEffect(e3)
    --Special Summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(14801013,1))
    e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1)
    e4:SetCondition(c14801013.spcon)
    e4:SetCost(c14801013.spcost)
    e4:SetTarget(c14801013.sptg)
    e4:SetOperation(c14801013.spop)
    c:RegisterEffect(e4)
end
function c14801013.cfilter(c,fc)
    return (c:IsFusionSetCard(0x4800) or c:IsFusionAttribute(ATTRIBUTE_DARK)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c14801013.spfilter1(c,tp,g)
    return g:IsExists(c14801013.spfilter2,1,c,tp,c)
end
function c14801013.spfilter2(c,tp,mc)
    return (c:IsFusionSetCard(0x4800) and mc:IsFusionAttribute(ATTRIBUTE_DARK)
        or c:IsFusionAttribute(ATTRIBUTE_DARK) and mc:IsFusionSetCard(0x4800))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c14801013.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c14801013.cfilter,tp,LOCATION_MZONE,0,nil,c)
    return mg:IsExists(c14801013.spfilter1,1,nil,tp,mg)
end
function c14801013.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c14801013.cfilter,tp,LOCATION_MZONE,0,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=mg:FilterSelect(tp,c14801013.spfilter1,1,1,nil,tp,mg)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=mg:FilterSelect(tp,c14801013.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_COST)
end
function c14801013.value(e,c)
    return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0x4800)*300
end
function c14801013.cfilter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14801013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801013.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801013.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801013.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c14801013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c14801013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c14801013.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c14801013.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end
function c14801013.setfilter(c)
    return c:IsSetCard(0xae) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c14801013.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c14801013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c14801013.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c14801013.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c14801013.spfilter(c)
    return c:IsSetCard(0x4800) and c:IsAbleToRemoveAsCost()
end
function c14801013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14801013.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end