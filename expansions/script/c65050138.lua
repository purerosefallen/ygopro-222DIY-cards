--闪耀侍者 沉静之黄玉
function c65050138.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65050138.ffilter,2,true)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(c65050138.val)
	c:RegisterEffect(e1)
	 --fusion-summon(fake)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65050138.con)
	e2:SetCost(c65050138.cost)
	e2:SetTarget(c65050138.target)
	e2:SetOperation(c65050138.activate)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c65050138.etarget)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c65050138.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5da8) and c:IsType(TYPE_MONSTER)
end
function c65050138.val(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65050138.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)*100
end

function c65050138.etarget(e,c)
	return c:IsSetCard(0x5da8) and c:IsFaceup() and not c:IsCode(65050138)
end
function c65050138.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c65050138.con(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c65050138.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(65050138)==0 end
	e:GetHandler():RegisterFlagEffect(65050138,RESET_CHAIN,0,1)
end
function c65050138.filter(c,e)
	return c:IsAbleToGrave() and c:IsFaceup() and c:IsLevelAbove(6) and not c:IsImmuneToEffect(e)
end
function c65050138.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c65050138.filter,tp,LOCATION_MZONE,0,2,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050138.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c65050138.filter,tp,LOCATION_ONFIELD,0,2,nil,e) then
		local g=Duel.SelectMatchingCard(tp,c65050138.filter,tp,LOCATION_MZONE,0,2,2,nil,e)
		if Duel.SendtoGrave(g,REASON_EFFECT)==2 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65050138.ffilter(c)
	return c:IsFusionSetCard(0x5da8) and c:IsLocation(LOCATION_ONFIELD) and c:IsLevelAbove(6)
end