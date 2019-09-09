--毒印声命
function c24562456.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24562456.e1tg)
	e1:SetOperation(c24562456.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c24562456.cost)
	e2:SetTarget(c24562456.e2tg)
	e2:SetOperation(c24562456.e2op)
	c:RegisterEffect(e2)
end
---e2
function c24562456.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c24562456.e2tgfil(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToRemove() and c:IsSetCard(0x9390)
end
function c24562456.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c24562456.e2tgfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24562456.e2tgfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c24562456.e2tgfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c24562456.e2mgfil(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_DECK)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24562456.mgfil1(c,fc,e,tp)
	return c:IsCode(table.unpack(fc.material)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24562456.e2op(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if not (rc:IsRelateToEffect(e) and rc:IsFaceup()) then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c24562456.mgfil1),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,rc,e,tp)
	local ct=mg:GetClassCount(Card.GetCode)
	if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 
		and ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and Duel.SelectYesNo(tp,aux.Stringid(24562456,0)) then
		local g=Group.CreateGroup()
		while ct>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=mg:Select(tp,1,1,nil)
			g:AddCard(sg:GetFirst())
			mg:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
			ct=ct-1
		end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
---e1
function c24562456.e1tgfil(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x9390) and c:IsCanBeFusionMaterial()
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c24562456.e1spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c24562456.e1spfil(c,e,tp,code)
	return aux.IsMaterialListCode(c,code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c24562456.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c24562456.e1tgfil(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c24562456.e1tgfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c24562456.e1tgfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24562456.e1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c24562456.e1spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode())
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end