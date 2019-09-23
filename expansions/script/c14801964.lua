--暗之恶魔 艾森
function c14801964.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,8,2)
    c:EnableReviveLimit()
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(14801964,0))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c14801964.negcon)
    e2:SetCost(c14801964.negcost)
    e2:SetTarget(c14801964.negtg)
    e2:SetOperation(c14801964.negop)
    c:RegisterEffect(e2)
    --cannot be target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
end
function c14801964.negcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c14801964.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14801964.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
        local cat=e:GetCategory()
        if bit.band(re:GetHandler():GetOriginalType(),TYPE_MONSTER)~=0 then
            e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
        else
            e:SetCategory(bit.band(cat,bit.bnot(CATEGORY_SPECIAL_SUMMON)))
        end
    end
end
function c14801964.negop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if not Duel.NegateActivation(ev) then return end
    if rc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK)
        and not rc:IsHasEffect(EFFECT_NECRO_VALLEY) then
        if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp)>0)
            and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
            and Duel.SelectYesNo(tp,aux.Stringid(14801964,1)) then
            Duel.BreakEffect()
            Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
            Duel.ConfirmCards(1-tp,rc)
        elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
            and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(14801964,2)) then
            Duel.BreakEffect()
            Duel.SSet(tp,rc)
            Duel.ConfirmCards(1-tp,rc)
        end
    end
end