--闪耀侍者 灿烂之黄金
function c65050131.initial_effect(c)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c65050131.val)
	c:RegisterEffect(e1)
	 --ritual-summon(fake)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65050131.con)
	e2:SetTarget(c65050131.target)
	e2:SetOperation(c65050131.activate)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c65050131.etarget)
	e3:SetValue(c65050131.efilter)
	c:RegisterEffect(e3)
end
function c65050131.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5da8) and c:IsType(TYPE_MONSTER)
end
function c65050131.val(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65050131.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)*100
end

function c65050131.etarget(e,c)
	return c:IsSetCard(0x5da8) and c:IsFaceup() and not c:IsCode(65050131)
end
function c65050131.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c65050131.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c65050131.rtfilter(c,rc)
	return c:IsSetCard(0x5da8)
end
function c65050131.filter(c,e,tp,m1,ft)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	local mg=m1:Filter(c65050131.rtfilter,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetLevel,9,c)
	else
		return ft>-1 and mg:IsExists(c65050131.mfilterf,1,nil,tp,mg,c)
	end
end
function c65050131.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,9,rc)
	else return false end
end
function c65050131.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return c65050131.filter(e:GetHandler(),e,tp,mg1,ft) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c65050131.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if c65050131.filter(tc,e,tp,mg1,ft) then
		local mg=mg1:Filter(c65050131.rtfilter,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumGreater(tp,Card.GetLevel,9,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c65050131.mfilterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumGreater(tp,Card.GetLevel,9,tc)
				mat:Merge(mat2)
			end
			Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end