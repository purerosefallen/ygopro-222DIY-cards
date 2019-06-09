--贾巴沃克
local m=11200207
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200207,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,11200207)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e7:SetCondition(cm.hspcon)
	e7:SetOperation(cm.hspop)
	c:RegisterEffect(e7)
end
function cm.desfilter1(c,e,tp)
	local lv=nil
	if c:IsType(TYPE_XYZ) then lv=c:GetRank()
	elseif c:IsType(TYPE_LINK) then lv=c:GetLink()*2 
	else lv=c:GetLevel() end
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
	and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_DECK,0,1,nil,lv+1,e,tp)
end
function cm.spfilter(c,lv,e,tp)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
	and c:IsRace(RACE_DRAGON) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.desfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=nil
	if tc:IsType(TYPE_XYZ) then lv=tc:GetRank()
	elseif tc:IsType(TYPE_LINK) then lv=tc:GetLink()*2 
	else lv=tc:GetLevel() end
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,lv+1,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			g:GetFirst():RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			g:GetFirst():RegisterEffect(e3)
		end
	end
end
function cm.relfilter1(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM) and c:IsReleasable()
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local rg=Duel.GetReleaseGroup(tp)
	return (g:GetCount()>0 or rg:GetCount()>0) and g:FilterCount(Card.IsReleasable,nil)==g:GetCount()
		and g:FilterCount(cm.relfilter1,nil)>=2
		and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
		and Duel.GetFlagEffect(tp,11200207)==0
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,11200207,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Release(g,REASON_COST)
	if g:FilterCount(cm.relfilter1,nil)>=1 then
	local atk=0
	local def=0
	local tc=g:GetFirst()
	while tc do
		local batk=tc:GetTextAttack()
		local bdef=tc:GetTextDefense()
		if batk>0 then
			atk=atk+batk
		end
		if bdef>0 then
			def=def+bdef
		end
		tc=g:GetNext()
	end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
	if g:FilterCount(cm.relfilter1,nil)>=4 then
		--immune
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_IMMUNE_EFFECT)
		e5:SetValue(cm.efilter)
		c:RegisterEffect(e5)
	end
	if g:FilterCount(cm.relfilter1,nil)>=6 then
		--remove
		local e7=Effect.CreateEffect(c)
		e7:SetCategory(CATEGORY_REMOVE)
		e7:SetType(EFFECT_TYPE_IGNITION)
		e7:SetRange(LOCATION_MZONE)
		e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e7:SetCountLimit(1)
		e7:SetTarget(cm.destg)
		e7:SetOperation(cm.desop)
		c:RegisterEffect(e7)
	end
end
function cm.qlifilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_LINK) then
			return ec:Getlink()*2<lv
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()*2<lv
		else
			return ec:GetOriginalLevel()*2<lv
		end
	else
		return false
	end
end
function cm.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return cm.qlifilter(e,te) end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end