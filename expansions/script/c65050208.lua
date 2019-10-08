--奇妙仙灵 幻翼
function c65050208.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon rule
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_EXTRA)
	e9:SetCondition(c65050208.sprcon)
	e9:SetOperation(c65050208.sprop)
	c:RegisterEffect(e9)
	--swap
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SWAP_BASE_AD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65050208.con)
	c:RegisterEffect(e1)
	--cannot trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c65050208.actop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c65050208.con1)
	e3:SetTarget(c65050208.tg)
	e3:SetOperation(c65050208.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCondition(c65050208.con2)
	c:RegisterEffect(e4)
end
function c65050208.sprfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(6) and c:IsAbleToGraveAsCost()
end
function c65050208.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c65050208.sprfilter2,1,c,tp,c,sc,lv)
end
function c65050208.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:IsLevel(lv) and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c65050208.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65050208.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65050208.sprfilter1,1,nil,tp,g,c)
end
function c65050208.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65050208.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c65050208.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c65050208.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end

function c65050208.con(e)
	return e:GetHandler():IsAttackPos()
end
function c65050208.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x9da8) and rc:IsLevelBelow(6) and ep==tp then
		Duel.SetChainLimit(c65050208.chainlm)
	end
end
function c65050208.chainlm(e,rp,tp)
	return tp==rp
end

function c65050208.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050208.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,65050211)
end
function c65050208.tgfil(c)
	return ((c:IsFaceup() and c:IsLevelBelow(6)) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToGrave()
end
function c65050208.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65050208.tgfil(chkc,tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c65050208.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	local g=Duel.SelectTarget(tp,c65050208.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c65050208.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end