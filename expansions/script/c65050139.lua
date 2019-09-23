--闪耀侍者随时等候
function c65050139.initial_effect(c)
	--act
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--changedamage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c65050139.con)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--rebirth
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c65050139.spcon)
	e3:SetTarget(c65050139.sptg)
	e3:SetOperation(c65050139.spop)
	c:RegisterEffect(e3)
end
function c65050139.damfil(c)
	return c:IsFaceup() and c:IsSetCard(0x5da8) and c:IsLevel(9)
end
function c65050139.con(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65050139.damfil,tp,LOCATION_MZONE,0,1,nil)
end

function c65050139.spconf1(c,tp)
	return c:GetPreviousControler()==tp
end
function c65050139.spconfil(c)
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x5da8) 
end
function c65050139.spcon(e,tp,eg,ep,ev,re,r,rp)
	local efg=eg:Filter(c65050139.spconf1,nil,tp)
	return efg:GetCount()==1 and c65050139.spconfil(efg:GetFirst())
end
function c65050139.filter(c,e,tp,m1,ft)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	local mg=m1
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return ft>0 and mg:CheckWithSumGreater(Card.GetLevel,c:GetLevel()) 
end
function c65050139.esrifil(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x5da8)
end
function c65050139.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local efg=eg:Filter(c65050139.spconf1,nil,tp)
	local efc=efg:GetFirst()
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c65050139.esrifil,tp,LOCATION_GRAVE,0,e:GetHandler())
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return c65050139.filter(efc,e,tp,mg1,ft) and e:GetHandler():GetFlagEffect(65050139)==0
	end
	e:GetHandler():RegisterFlagEffect(65050139,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65050139.spop(e,tp,eg,ep,ev,re,r,rp)
	local efg=eg:Filter(c65050139.spconf1,nil,tp)
	local efc=efg:GetFirst()
	if not efc:IsLocation(LOCATION_GRAVE) then return end
	local mg1=Duel.GetMatchingGroup(c65050139.esrifil,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c65050139.filter(efc,e,tp,mg1,ft) then
		local mg=mg1
			if efc.mat_filter then
				mg=mg:Filter(efc.mat_filter,nil)
			end
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumGreater(tp,Card.GetLevel,efc:GetLevel())
			end
			Duel.SendtoDeck(mat,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(efc,0,tp,tp,false,false,POS_FACEUP)
	end
end