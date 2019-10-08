--升阶魔法-熟成之甜味
function c65050178.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65050178.target)
	e1:SetOperation(c65050178.activate)
	c:RegisterEffect(e1)
	--become
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65050178.con)
	e2:SetTarget(c65050178.tg)
	e2:SetOperation(c65050178.op)
	c:RegisterEffect(e2)
end
function c65050178.confil(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c65050178.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65050178.confil,1,nil)
end
function c65050178.xtgfil(c)
	return c:IsFaceup() and c:IsSetCard(0x6da8) and c:IsType(TYPE_XYZ)
end
function c65050178.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050178.xtgfil(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050178.xtgfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c65050178.xtgfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65050178.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,c)
	end
end

function c65050178.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsSetCard(0x6da8) and c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c65050178.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+3)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c65050178.filter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0x6da8) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c65050178.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65050178.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65050178.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c65050178.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65050178.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65050178.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+3)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
			sc:CompleteProcedure()
			sc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		end
	end
end