--御刀使-燕结芽
local m=20100229
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100000") end,function() require("script/c20100000") end)
function cm.initial_effect(c)
	C9.TojiMonster(c)
	aux.EnablePendulumAttribute(c)
	--Battle!!
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(cm.bacon)
	e1:SetTarget(cm.batg)
	e1:SetOperation(cm.baop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)   
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.spcon2)
	e3:SetOperation(cm.spop2)
	c:RegisterEffect(e3)		 
end

function cm.bacon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()~=tp
end

function cm.bafilter1(c)
	return c:IsAttackable() and c:IsSetCard(0xc90) and c:IsFaceup()
end

function cm.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.bafilter1,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsDestructable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,cm.bafilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end

function cm.baop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=2 then return end
	local ac=tg:Filter(Card.IsControler,nil,tp):GetFirst()
	local at=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	Duel.CalculateDamage(ac,at)
end
	
function cm.rfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc91) and c:IsReleasable()
end

function cm.mfilter(c)
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE)
end

function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_ONFIELD,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then 
		return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_ONFIELD,0,2,nil) 
	else
		return rg:GetCount()>1 and rg:IsExists(cm.mfilter,1,nil)
	end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_ONFIELD,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,cm.mfilter,1,1,nil)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	end
	Duel.Release(g,REASON_COST)
end

function cm.spfilter(c)
	return c:IsSetCard(0xc91) and c:IsReleasable() and c:IsFaceup()
end
function cm.spfilter1(c,tp,g)
	return g:IsExists(cm.spfilter2,1,c,tp,c)
end
function cm.spfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function cm.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:IsExists(cm.spfilter1,1,nil,tp,g)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_ONFIELD,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,cm.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,cm.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end