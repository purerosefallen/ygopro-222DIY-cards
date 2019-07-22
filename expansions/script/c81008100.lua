--鹭泽文香
function c81008100.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81008100,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c81008100.linkcon)
	e1:SetOperation(c81008100.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function c81008100.lmfilter(c,lc)
	local tp=lc:GetControler()
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsLink(3) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c81008100.linkcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c81008100.lmfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function c81008100.linkop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,c81008100.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_LINK)
end
