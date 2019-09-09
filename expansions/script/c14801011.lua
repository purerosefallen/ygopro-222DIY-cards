--灾厄守卫 金古桥
function c14801011.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x4800),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WIND),true)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c14801011.sprcon)
    e1:SetOperation(c14801011.sprop)
    c:RegisterEffect(e1)
    --atk/def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(c14801011.val)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --indes/untarget
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4800))
    e4:SetValue(c14801011.atlimit)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e5:SetValue(aux.tgoval)
    c:RegisterEffect(e5)
    --special summon
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(14801011,0))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetRange(LOCATION_GRAVE)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetCondition(aux.exccon)
    e7:SetCost(aux.bfgcost)
    e7:SetTarget(c14801011.spbtg)
    e7:SetOperation(c14801011.spbop)
    c:RegisterEffect(e7)
end
function c14801011.cfilter(c,fc)
    return (c:IsFusionSetCard(0x4800) or c:IsFusionAttribute(ATTRIBUTE_WIND)) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function c14801011.spfilter1(c,tp,g)
    return g:IsExists(c14801011.spfilter2,1,c,tp,c)
end
function c14801011.spfilter2(c,tp,mc)
    return (c:IsFusionSetCard(0x4800) and mc:IsFusionAttribute(ATTRIBUTE_WIND)
        or c:IsFusionAttribute(ATTRIBUTE_WIND) and mc:IsFusionSetCard(0x4800))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c14801011.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c14801011.cfilter,tp,LOCATION_MZONE,0,nil,c)
    return mg:IsExists(c14801011.spfilter1,1,nil,tp,mg)
end
function c14801011.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c14801011.cfilter,tp,LOCATION_MZONE,0,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=mg:FilterSelect(tp,c14801011.spfilter1,1,1,nil,tp,mg)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=mg:FilterSelect(tp,c14801011.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_COST)
end
function c14801011.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x4800)
end
function c14801011.val(e,c)
    return Duel.GetMatchingGroupCount(c14801011.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*300
end
function c14801011.atlimit(e,c)
    return c~=e:GetHandler()
end
function c14801011.spbfilter(c,e,tp)
    return c:IsSetCard(0x4800) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14801011.spbtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14801011.spbfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c14801011.spbfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c14801011.spbfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c14801011.spbop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end